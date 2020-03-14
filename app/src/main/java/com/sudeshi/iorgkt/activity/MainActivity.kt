package com.sudeshi.iorgkt.activity

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.sudeshi.iorgkt.R
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        txtView.text = "hihiihi"
    }
}
