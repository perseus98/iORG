package com.sudeshi.iorgkt.activity

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import androidx.appcompat.app.AppCompatActivity
import com.sudeshi.iorgkt.R

class SplashActivity : AppCompatActivity() {
    private val SPLASH_TIME_OUT: Long = 1500
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        Handler().postDelayed(
            {
                startActivity(Intent(this, Dashboard::class.java))
                finish()
            }, SPLASH_TIME_OUT
        )
    }

}