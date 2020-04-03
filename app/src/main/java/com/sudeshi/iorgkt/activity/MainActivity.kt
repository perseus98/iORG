package com.sudeshi.iorgkt.activity

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.pm.ActivityInfo
import android.os.Bundle
import android.os.Handler
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.RecyclerView
import com.sudeshi.iorgkt.R
import com.sudeshi.iorgkt.adapter.AdapterRecyclerView
import com.sudeshi.iorgkt.db.model.Data
import com.sudeshi.iorgkt.viewModel.DataViewModel
import kotlinx.android.synthetic.main.activity_main.*
import java.time.OffsetDateTime
import java.time.format.DateTimeFormatter
import java.util.*

class MainActivity : AppCompatActivity() {


    var NEW_CREATE_ACTIVITY_REQUEST_CODE: Int = 1
    private var doubleBackToExitPressedOnce: Boolean = false
    private var layoutManager: RecyclerView.LayoutManager? = null
    private var adapter: RecyclerView.Adapter<AdapterRecyclerView.ViewHolder>? = null
    var formmat1: DateTimeFormatter =
        DateTimeFormatter.ofPattern("dd/MM/yyyy::HH:mm:ss", Locale.ENGLISH)
    private lateinit var dataViewModel: DataViewModel


    @SuppressLint("SourceLockedOrientationActivity")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        dataViewModel = ViewModelProvider(this).get(DataViewModel::class.java)


//        layoutManager = LinearLayoutManager(this)
//        rv_main.layoutManager = layoutManager
//
//        adapter = AdapterRecyclerView()
//        rv_main.adapter = adapter

        efab_create.setOnClickListener {
//            startActivity(Intent(this, CreateActivity::class.java))
            startActivityForResult(
                Intent(this, CreateActivity::class.java),
                NEW_CREATE_ACTIVITY_REQUEST_CODE
            )
        }
    }

    override fun onBackPressed() {
        if (doubleBackToExitPressedOnce) {
            super.onBackPressed()
            return
        }
        this.doubleBackToExitPressedOnce = true
        Toast.makeText(this, "Press back again to exit", Toast.LENGTH_SHORT).show()
        Handler().postDelayed({ doubleBackToExitPressedOnce = false }, 2000)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == NEW_CREATE_ACTIVITY_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            data?.let { data ->
                var recvDataMap: HashMap<String, Any?> =
                    data.getSerializableExtra("com.sudeshi.iorgkt.newData.REPLY") as HashMap<String, Any?>
                val newData = Data(
                    0,
                    recvDataMap["name"].toString(),
                    recvDataMap["path"].toString(),
                    recvDataMap["date"] as OffsetDateTime,
                    recvDataMap["prty"] as Int
                )
                dataViewModel.insert(newData)
                Toast.makeText(
                    applicationContext,
                    R.string.dataInsSuccess,
                    Toast.LENGTH_LONG
                ).show()
                Unit
            }

        } else {
            Toast.makeText(
                applicationContext,
                R.string.taskFailed,
                Toast.LENGTH_LONG
            ).show()
//            jujujuj
        }
    }

}
