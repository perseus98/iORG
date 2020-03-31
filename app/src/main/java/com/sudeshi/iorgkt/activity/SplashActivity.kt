package com.sudeshi.iorgkt.activity

import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.ActivityInfo
import android.os.Bundle
import android.os.Handler
import androidx.appcompat.app.AppCompatActivity
import com.sudeshi.iorgkt.R

class SplashActivity : AppCompatActivity() {
    private val timeOut: Long = 1000

    @SuppressLint("SourceLockedOrientationActivity")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)
        requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT


        Handler().postDelayed(
            {
                startActivity(Intent(this, MainActivity::class.java))
                finish()
            }, timeOut
        )
    }

}