package com.sudeshi.iorgkt.activity

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.ActivityInfo
import android.os.Bundle
import android.os.Handler
import android.widget.GridLayout
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.multidex.MultiDex
import androidx.recyclerview.widget.GridLayoutManager
import com.sudeshi.iorgkt.R
import com.sudeshi.iorgkt.adapter.DataRecyclerViewAdapter
import com.sudeshi.iorgkt.adapter.GridItemDecoration
import com.sudeshi.iorgkt.db.model.Data
import com.sudeshi.iorgkt.viewModel.DataViewModel
import kotlinx.android.synthetic.main.activity_main.*
import java.time.OffsetDateTime
import java.time.format.DateTimeFormatter
import java.util.*

class MainActivity : AppCompatActivity() {


    var NEW_CREATE_ACTIVITY_REQUEST_CODE: Int = 1
    private var doubleBackToExitPressedOnce: Boolean = false

    //    private var adapter: RecyclerView.Adapter<DataListViewHolder.ViewHolder>? = null
    var formmat1: DateTimeFormatter =
        DateTimeFormatter.ofPattern("dd/MM/yyyy::HH:mm:ss", Locale.ENGLISH)
    private lateinit var dataViewModel: DataViewModel
    private var SPAN_COUNT: Int = 2
    private var GRID_ORIEN: Int = GridLayout.HORIZONTAL
    private var GRID_REV_LAYOUT: Boolean = true
    val dataListAdapter = DataRecyclerViewAdapter()


    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
    @SuppressLint("SourceLockedOrientationActivity")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        initActConfig()
//        initActText()
        initActViewModel()
        initActBtn()
    }

    @SuppressLint("SourceLockedOrientationActivity", "WrongConstant")
    private fun initActConfig() {
        this.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        recyclerViewMain.layoutManager =
            GridLayoutManager(this, SPAN_COUNT, GRID_ORIEN, GRID_REV_LAYOUT)
        recyclerViewMain.addItemDecoration(GridItemDecoration(10, 2))
        recyclerViewMain.adapter = dataListAdapter
//        dataListAdapter.setDataList(generateDummyData())
//        currentLayoutManagerType = LayoutManagerType.GRID_LAYOUT_MANAGER
    }

    private fun initActViewModel() {
        dataViewModel = ViewModelProvider(this).get(DataViewModel::class.java)
        dataViewModel.allData.observe(this, Observer { datas ->
            datas?.let { dataListAdapter.setDataList(it) }
        })
    }

    private fun initActBtn() {
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
                val recvDataMap: HashMap<String, Any?> =
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
        }
    }

    //    private fun generateDummyData() : List<Data> {
//        val dataList = mutableListOf<Data>()
//
//        var movieModel = Data(1, "Avengers", R.drawable.sample, "16 Feb 2018", R.drawable.ic_avengers)
//        dataList.add(movieModel)
//
//        movieModel = Data(2, "Avengers: Age of Ultron", 400, "17 March 2018", R.drawable.ic_avengers_2)
//        dataList.add(movieModel)
//
//        movieModel = Data(3, "Iron Man 3", 550, "17 April 2018", R.drawable.ic_ironman_3)
//        dataList.add(movieModel)
//
//        movieModel = Data(4, "Avengers: Infinity War", 1500, "15 Jan 2018", R.drawable.ic_avenger_five)
//        dataList.add(movieModel)
//
//        movieModel = Data(5, "Thor: Ragnarok", 200, "17 March 2018", R.drawable.ic_thor)
//        dataList.add(movieModel)
//
//        movieModel = Data(6, "Black Panther", 250, "17 May 2018", R.drawable.ic_panther)
//        dataList.add(movieModel)
//
//        movieModel = Data(7, "Logan", 320, "17 Dec 2018", R.drawable.ic_logan)
//        dataList.add(movieModel)
//
//        return dataList
//    }
    private fun extraDummyContent() {
//        initActSeekbar()
//        layoutManager = LinearLayoutManager(this)
//        rv_main.layoutManager = layoutManager
//
//        adapter = DataListViewHolder()
//        rv_main.adapter = adapter
    }
}
