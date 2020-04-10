package com.sudeshi.iorgkt.activity

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.ActivityInfo
import android.os.Bundle
import android.os.Handler
import android.view.Menu
import android.view.MenuItem
import android.widget.GridLayout
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.view.ActionMode
import androidx.appcompat.widget.Toolbar
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.multidex.MultiDex
import androidx.recyclerview.widget.GridLayoutManager
import com.sudeshi.iorgkt.R
import com.sudeshi.iorgkt.adapter.GridItemDecoration
import com.sudeshi.iorgkt.adapter.RecyclerViewAdapter
import com.sudeshi.iorgkt.db.model.Data
import com.sudeshi.iorgkt.extension.MainInterface
import com.sudeshi.iorgkt.viewModel.DataViewModel
import kotlinx.android.synthetic.main.activity_main.*
import java.time.OffsetDateTime
import java.time.format.DateTimeFormatter
import java.util.*


class MainActivity : AppCompatActivity(), MainInterface {
    var NEW_CREATE_ACTIVITY_REQUEST_CODE: Int = 1
    private var doubleBackToExitPressedOnce: Boolean = false

    //    private var adapter: RecyclerView.Adapter<RecyclerViewHolder.ViewHolder>? = null
    var formmat1: DateTimeFormatter =
        DateTimeFormatter.ofPattern("dd/MM/yyyy::HH:mm:ss", Locale.ENGLISH)
    private lateinit var dataViewModel: DataViewModel
    private var spanCount: Int = 2
    private var gridOrientation: Int = GridLayout.VERTICAL
    private var gridReverseLayout: Boolean = false
    private val dataListAdapter = RecyclerViewAdapter(this, this)
    var actionMode: ActionMode? = null

    companion object {
        var isMultiSelectOn = false
        val TAG = "MainActivity"
    }
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
    @SuppressLint("SourceLockedOrientationActivity")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        initActConfig()
        initActToolbar()
        initActViewModel()
        initActBtn()
    }
    @SuppressLint("SourceLockedOrientationActivity", "WrongConstant")
    private fun initActConfig() {
        this.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        isMultiSelectOn = false
        recyclerViewMain.layoutManager =
            GridLayoutManager(this, spanCount, gridOrientation, gridReverseLayout)
        recyclerViewMain.addItemDecoration(GridItemDecoration(10, 2))
        recyclerViewMain.adapter = dataListAdapter
//        dataListAdapter.setDataList(generateDummyData())
//        currentLayoutManagerType = LayoutManagerType.GRID_LAYOUT_MANAGER
    }

    private fun initActToolbar() {
        toolBar.inflateMenu(R.menu.toolbar)
        toolBar.setOnMenuItemClickListener(Toolbar.OnMenuItemClickListener { item ->
            return@OnMenuItemClickListener when (item.itemId) {
                R.id.action_refresh -> {
                    Toast.makeText(this, "Refreshing...", Toast.LENGTH_SHORT).show()
                    true
                }
                else -> false
            }
        })
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

        } else if (requestCode == NEW_CREATE_ACTIVITY_REQUEST_CODE && resultCode == Activity.RESULT_CANCELED) {
            Toast.makeText(
                applicationContext,
                R.string.taskTermination,
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    override fun mainInterface(size: Int) {
        if (actionMode == null) actionMode = startSupportActionMode(ActionModeCallback())
        if (size > 0) actionMode?.title = "$size"
        else actionMode?.finish()
    }

    inner class ActionModeCallback : ActionMode.Callback {
        var shouldResetRecyclerView = true
        override fun onActionItemClicked(mode: ActionMode?, item: MenuItem?): Boolean {
            when (item?.itemId) {
                R.id.action_delete -> {
                    shouldResetRecyclerView = false

//                    RecyclerViewAdapter?.deleteSelectedIds()
                    actionMode?.title = "" //remove item count from action mode.
                    actionMode?.finish()
                    return true
                }
            }
            return false
        }

        override fun onCreateActionMode(mode: ActionMode?, menu: Menu?): Boolean {
            val inflater = mode?.menuInflater
            inflater?.inflate(R.menu.toolbar_cab, menu)
            return true
        }

        override fun onPrepareActionMode(mode: ActionMode?, menu: Menu?): Boolean {
            menu?.findItem(R.id.action_delete)?.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
            return true
        }

        override fun onDestroyActionMode(mode: ActionMode?) {
            if (shouldResetRecyclerView) {
//                RecyclerViewAdapter?.selectedIds?.clear()
//                RecyclerViewAdapter?.notifyDataSetChanged()
            }
            isMultiSelectOn = false
            actionMode = null
            shouldResetRecyclerView = true
        }
    }
}
