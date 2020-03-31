package com.sudeshi.iorgkt.activity

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.sudeshi.iorgkt.R
import kotlinx.android.synthetic.main.activity_dashboard.*

class Dashboard : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dashboard)
        card_view_create.setOnClickListener {
            startActivity(Intent(this, CreateActivity::class.java))
        }
        card_view_add_tag.setOnClickListener {
            startActivity(Intent(this, MainActivity::class.java))
        }
    }
}
