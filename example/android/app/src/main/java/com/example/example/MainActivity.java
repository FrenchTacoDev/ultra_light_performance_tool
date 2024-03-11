package com.example.example;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.Nullable;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Objects;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        //Opens up flutters method channel to communicate with the dart side
        MethodChannel methodChannel = new MethodChannel(
                Objects.requireNonNull(this.getFlutterEngine()).getDartExecutor().getBinaryMessenger(),
                "nativeCommChannel"
        );


        Intent intent = getIntent();
        if(intent == null) return;
        String cachePath = handlePerfFileIntent(intent);
        if(cachePath == null) return;
        //Send the cached filepath to the dart side
        methodChannel.invokeMethod("onArgsFromNative", cachePath);
    }

    //This function takes the content intent and
    //1 reads its data, 2 copies the data to the app cache directory, 3 returns the cached files path.
    //This is necessary because we do not have permission to read storage files on android out of the box.
    private String handlePerfFileIntent(Intent intent){

        Uri uri = intent.getData();
        if(uri == null) return null;

        String path = getCacheDir() + "/" + "tempPerfData.ulpt";
        File outputFile = new File(path);
        if(outputFile.exists()) outputFile.delete();

        try {
            InputStream is = getContentResolver().openInputStream(uri);
            if(is == null) return null;
            FileOutputStream os = new FileOutputStream(outputFile, false);

            byte[] buffer = new byte[4096];
            int b;

            while((b = is.read(buffer)) != -1){
                os.write(buffer, 0, b);
            }

            os.close();
            is.close();
        } catch (IOException e) {
            return null;
        }

        return path;
    }
}
