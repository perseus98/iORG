package com.sudeshi.iorgkt.activity

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.ActivityInfo
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore.ACTION_IMAGE_CAPTURE
import android.provider.MediaStore.EXTRA_OUTPUT
import android.widget.SeekBar
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.multidex.MultiDex
import com.sudeshi.iorgkt.R
import com.sudeshi.iorgkt.R.color.colorWhite
import com.sudeshi.iorgkt.R.drawable
import com.sudeshi.iorgkt.R.layout
import com.sudeshi.iorgkt.extension.openDateTimePicker
import com.sudeshi.iorgkt.viewModel.DateViewModel
import kotlinx.android.synthetic.main.activity_create.*
import kotlinx.android.synthetic.main.activity_create.view.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import java.io.File
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*


class CreateActivity : AppCompatActivity() {

    private var currentPhotoPath: String? = null
    private val requestTakePic = 1
    private val currentTimeStamp: String =
        SimpleDateFormat("yyyyMMddHHmmss", Locale.US).format(Date())
    private val extraReply: String = "com.sudeshi.iorgkt.newData.REPLY"
    private lateinit var dateViewModel: DateViewModel
    private var datePickerJob: Job? = null
    private val uiScope = CoroutineScope(Dispatchers.Main.immediate)
    private var seekBarProgress = 0
    private var entriesValid = false
    private var picTaken = false
    val tag: String = "CreateActivity"

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(layout.activity_create)
        initActConfig()
        initActText()
        initActViewModel()
        initActBtn()
        initActSeekbar()
//        Toast.makeText(applicationContext,"Picture Okk",Toast.LENGTH_LONG).show()
    }

    @SuppressLint("SourceLockedOrientationActivity")
    private fun initActConfig() {
        this.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
    }

    private fun initActViewModel() {
        dateViewModel = ViewModelProvider(this).get(DateViewModel::class.java)
        dateViewModel.dateTimeText.observe(this, Observer { offsetDateTime ->
            offsetDateTime?.let {
                outlinedTextCalander?.editTextCalander?.setText(dateViewModel.getDateTimeForTextView())
            } //the call to setNewDateTime will refresh this value
        })
    }

    private fun initActBtn() {
        btn_captureImg.setImageDrawable(
            ContextCompat.getDrawable(
                applicationContext, // Context
                drawable.ic_add_a_photo_black_100dp // Drawable
            )
        )
        btn_captureImg.setOnClickListener {
            dispatchTakePictureIntent()
        }
        btnBack.setOnClickListener {
//            startActivity(Intent(this,MainActivity::class.java))
            setResult(Activity.RESULT_CANCELED)
            finish()
        }
        btnCreate.setOnClickListener {
            if (currentPhotoPath != null && picTaken && entriesValid) {
                val newDataMap: HashMap<String, Any?> = HashMap(
                    mutableMapOf(
                        "name" to (outlinedTextName?.editTextName?.text),
                        "date" to dateViewModel.getDateTimeForDB(),
                        "path" to currentPhotoPath,
                        "prty" to seekBarProgress
                    )
                )
                val intentToMain = Intent()
                intentToMain.putExtra(extraReply, newDataMap)
                setResult(Activity.RESULT_OK, intentToMain)
                finish()
            } else
                Toast.makeText(
                    applicationContext,
                    getString(R.string.picNotFound),
                    Toast.LENGTH_LONG
                ).show()
        }
    }

    private fun initActText() {
        outlinedTextName.editTextName?.setText(
            applicationContext.getString(
                R.string.entryName,
                currentTimeStamp
            )
        )
        outlinedTextName.editTextName?.setTextColor(getColor(colorWhite))
        outlinedTextCalander.editTextCalander.keyListener = null
        outlinedTextCalander.editTextCalander?.setTextColor(getColor(colorWhite))
    }

    private fun initActSeekbar() {
        seekBarPriority.max = 5
        seekBarPriority.progress = 0
        seekBarPriority?.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onStartTrackingTouch(seekBar: SeekBar?) {
            }
            override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                seekBarProgress = progress
            }
            override fun onStopTrackingTouch(seekBar: SeekBar?) {
                Toast.makeText(
                    applicationContext,
                    "Selected Priority Level : $seekBarProgress",
                    Toast.LENGTH_SHORT
                ).show()
            }
        })
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == Activity.RESULT_CANCELED && requestCode == requestTakePic) {
            entriesValid = false
            picTaken = false
            Toast.makeText(
                applicationContext,
                getString(R.string.imgCapTerminated),
                Toast.LENGTH_SHORT
            ).show()
        } else if (resultCode != Activity.RESULT_CANCELED && requestCode == requestTakePic) {
            val bitmap: Bitmap? = BitmapFactory.decodeFile(currentPhotoPath)
            btn_captureImg.setImageBitmap(bitmap)
            entriesValid = true
            picTaken = true
//                        Log.d(TAG, bitmap.toString())
        }
    }

    private fun dispatchTakePictureIntent() {
        Intent(ACTION_IMAGE_CAPTURE).also { takePictureIntent ->
            takePictureIntent.resolveActivity(packageManager)?.also {
                val photoFile: File? = try {
                    createImageFile()
                } catch (ex: IOException) {
                    Toast.makeText(
                        applicationContext,
                        "Couldn't create/take picture",
                        Toast.LENGTH_LONG
                    ).show()
                    null
                }
                // Continue only if the File was successfully created
                photoFile?.also { 
                    val photoURI: Uri = FileProvider.getUriForFile(
                        this,
                        "com.sudeshi.iorgkt.fileprovider",
                        it
                    )
                    takePictureIntent.putExtra(EXTRA_OUTPUT, photoURI)
                    startActivityForResult(takePictureIntent, requestTakePic)
                }
            }
        }
    }

    @Throws(IOException::class)
    private fun createImageFile(): File {
        // Create an image file name
        val storageDir: File? = filesDir
        return File.createTempFile(
            "JPEG_${currentTimeStamp}_", /* prefix */
            ".jpg", /* suffix */
            storageDir /* directory */
        ).apply {
            currentPhotoPath = absolutePath
        }
    }

    override fun onStart() {
        super.onStart()
        outlinedTextCalander.editTextCalander.setOnClickListener {
            datePickerJob = uiScope.launch {
                dateViewModel.setNewDateTime(openDateTimePicker())
            }
        }

    }

    override fun onStop() {
        super.onStop()
        outlinedTextCalander.editTextCalander.setOnClickListener(null)
        datePickerJob?.cancel()
    }

}
