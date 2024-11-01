package com.tridevi.rent_house.rent_house;

import android.annotation.SuppressLint;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.IntentFilter;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.nfc.tech.IsoDep;
import android.nfc.tech.NfcA;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "nfc";
    private static IsoDep isoDep = null;
    private static NfcA nfcA = null;
    private NfcAdapter mAdapter;
    private PendingIntent mPendingIntent;
    private IntentFilter[] mFilters;
    private String[][] mTechLists;

    public static String byteArrayToHexString(byte[] bytes) {
        final char[] hexArray = "0123456789ABCDEF".toCharArray();
        char[] hexChars = new char[bytes.length * 2];
        for (int j = 0; j < bytes.length; j++) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

    public static byte[] hexStringToByteArray(String s) throws IllegalArgumentException {
        int len = s.length();
        if (len % 2 != 0) {
            throw new IllegalArgumentException("Hex string must have even number of characters");
        }
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                    + Character.digit(s.charAt(i + 1), 16));
        }
        return data;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Log.i("NFC", "onCreate");

        mAdapter = NfcAdapter.getDefaultAdapter(this);
        if (mAdapter == null) {
            Log.e("NFC", "NFC is not supported on this device");
            return;
        }

        mPendingIntent = PendingIntent.getActivity(
                this, 0, new Intent(this, getClass()).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), PendingIntent.FLAG_IMMUTABLE);

        mFilters = new IntentFilter[]{new IntentFilter(NfcAdapter.ACTION_TECH_DISCOVERED)};
        mTechLists = new String[][]{new String[]{IsoDep.class.getName(), NfcA.class.getName()}};

        new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "getPlatformVersion":
                            result.success("Android " + android.os.Build.VERSION.RELEASE);
                            break;
                        case "getCardUID":
                            result.success(getCardUID());
                            break;
                        case "getVersion":
                            String commands = call.argument("commands");
                            result.success(getVersion(commands));
                            break;
                        default:
                            result.notImplemented();
                    }
                });
    }

    @SuppressLint("MissingPermission")
    @Override
    protected void onResume() {
        super.onResume();
        Log.i("NFC", "onResume");
        if (mAdapter != null) {
            mAdapter.enableForegroundDispatch(this, mPendingIntent, mFilters, mTechLists);
        }
    }

    @SuppressLint("MissingPermission")
    @Override
    public void onPause() {
        super.onPause();
        Log.i("NFC", "onPause");
        if (mAdapter != null) {
            mAdapter.disableForegroundDispatch(this);
        }
    }

    @SuppressLint("MissingPermission")
    private void setIsoDepAndNfcA(Intent intent) {
        try {
            Log.i("NFC", "setIsoDepAndNfcA entered");
            if (intent == null) {
                Log.e("NFC", "Intent is null");
                return;
            }
            Tag tag = intent.getParcelableExtra(NfcAdapter.EXTRA_TAG);

            if (tag == null) {
                Log.e("NFC", "Tag is null");
                return;
            }

            // Get the IsoDep instance
            isoDep = IsoDep.get(tag);
            // Get the NfcA instance
            nfcA = NfcA.get(tag);

            // Try to connect using IsoDep first
            if (isoDep != null) {
                isoDep.connect();
                Log.i("NFC", "ISO-DEP connected");
            } else if (nfcA != null) {
                nfcA.connect();
                Log.i("NFC", "NFC-A connected");
            } else {
                Log.e("NFC", "Neither IsoDep nor NfcA technology is supported");
            }
        } catch (Exception e) {
            Log.e("NFC", "Error in setIsoDepAndNfcA", e);
        }
    }

    private String getCardUID() {
        try {
            if (isoDep != null && isoDep.isConnected()) {
                byte[] uid = isoDep.getTag().getId();
                return byteArrayToHexString(uid);
            } else if (nfcA != null && nfcA.isConnected()) {
                byte[] uid = nfcA.getTag().getId();
                return byteArrayToHexString(uid);
            } else {
                Log.i("NFC", "Not connected or isoDep/nfcA is null");
                return "Not connected";
            }
        } catch (Exception e) {
            Log.e("NFC", "Error in getCardUID", e);
            return e.toString();
        }
    }

    @SuppressLint("MissingPermission")
    private String getVersion(String commands) {
        Log.i("NFC", "getVersion called with commands: " + commands);
        try {
            StringBuilder responses = new StringBuilder();
            String[] cmdArray = commands.split("#");

            // Use IsoDep if available
            if (isoDep != null && isoDep.isConnected()) {
                for (String cmd : cmdArray) {
                    Log.i("NFC", "Sending command to IsoDep: " + cmd);
                    byte[] command = hexStringToByteArray(cmd);
                    byte[] response = isoDep.transceive(command);
                    responses.append(byteArrayToHexString(response));
                }
            }
            // Use NfcA if IsoDep is not available
            else if (nfcA != null && nfcA.isConnected()) {
                for (String cmd : cmdArray) {
                    Log.i("NFC", "Sending command to NfcA: " + cmd);
                    byte[] command = hexStringToByteArray(cmd);
                    // You will need to implement the command sending logic for NfcA
                    // Example: byte[] response = nfcA.transceive(command);
                    // responses.append(byteArrayToHexString(response));
                }
            } else {
                Log.i("NFC", "Not connected or isoDep/nfcA is null");
                return "Not connected";
            }
            return responses.toString();
        } catch (Exception e) {
            Log.e("NFC", "Error in getVersion", e);
            return e.toString();
        }
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        Log.i("NFC", "onNewIntent called");
        if (NfcAdapter.ACTION_TECH_DISCOVERED.equals(intent.getAction())) {
            setIsoDepAndNfcA(intent);
        } else {
            Log.i("NFC", "NFC Intent action not recognized");
        }
    }
}
