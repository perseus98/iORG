package com.sudeshi.iorgkt.activity

import android.annotation.SuppressLint
import android.app.Activity
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
import com.sudeshi.iorgkt.R.color.colorWhite
import com.sudeshi.iorgkt.R.drawable
import com.sudeshi.iorgkt.R.layout
import com.sudeshi.iorgkt.support.openDateTimePicker
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
import java.time.OffsetDateTime
import java.util.*


class CreateActivity : AppCompatActivity() {

    private var currentPhotoPath: String? = null
    private val REQUEST_TAKE_PHOTO = 1
    private val currentTimeStamp: String =
        SimpleDateFormat("yyyyMMddHHmmss", Locale.US).format(Date())
    //    private val currDateSDF: String = SimpleDateFormat("dd/MM/yyyy::HH:mm:ss", Locale.US).format(Date())
    //    private var dateTime: String = DateTimeFormatter.ofPattern("dd/MM/yyyy::HH:mm:ss", Locale.ENGLISH).format(LocalDateTime.now())
    //    private var dateTime2: OffsetDateTime =OffsetDateTime.of(LocalDateTime.parse("dd/MM/yyyy::HH:mm:ss"), ZoneOffset.of("+05:30"))
    val EXTRA_REPLY: String = "com.sudeshi.iorgkt.newData.REPLY"
    private lateinit var dateViewModel: DateViewModel
    private var datePickerJob: Job? = null
    private val uiScope = CoroutineScope(Dispatchers.Main.immediate)
    private var seekBarProgress = 0
//    val TAG: String = "CreateActivity"

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
                outlinedTextCalander?.editTextCalander?.setText(dateViewModel.getDateTime())
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
//            Toast.makeText(applicationContext,"Picture Okk",Toast.LENGTH_LONG).show()
        }
        btnBack.setOnClickListener {
//            startActivity(Intent(this, MainActivity::class.java))
//            Toast.makeText(applicationContext, currDateSDF, Toast.LENGTH_LONG).show()
        }
        btnCreate.setOnClickListener {
            if (currentPhotoPath != null) {
                val newDataMap: HashMap<String, Any?> = HashMap(
                    mutableMapOf(
                        "name" to (outlinedTextName?.editTextName?.text),
                        "date" to OffsetDateTime.parse(outlinedTextCalander?.editTextCalander?.text),
                        "path" to currentPhotoPath,
                        "prty" to seekBarProgress
                    )
                )
                val intent = Intent()
                intent.putExtra(EXTRA_REPLY, newDataMap)
                setResult(Activity.RESULT_OK, intent)
                finish()
            } else
                Toast.makeText(applicationContext, "PICTURE NOT FOUND", Toast.LENGTH_LONG).show()
        }
    }

    private fun initActText() {
        outlinedTextName.editTextName?.setText("entry_$currentTimeStamp")
        outlinedTextName.editTextName?.setTextColor(getColor(colorWhite))
        outlinedTextCalander.editTextCalander.keyListener = null
//        outlinedTextCalander.editTextCalander?.setText(currDateSDF)
        outlinedTextCalander.editTextCalander?.setTextColor(getColor(colorWhite))
    }

    private fun initActSeekbar() {
        seekBarPriority?.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                seekBarProgress = progress
//                Toast.makeText(
//                    applicationContext,
//                    "Priority Level : $seekBarProgress",
//                    Toast.LENGTH_SHORT
//                ).show()

            }

            override fun onStartTrackingTouch(seekBar: SeekBar?) {
//                Toast.makeText(
//                    applicationContext,
//                    "discrete seekbar touch started!",
//                    Toast.LENGTH_SHORT
//                ).show()
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
        if (resultCode != Activity.RESULT_CANCELED) {
            if (requestCode == REQUEST_TAKE_PHOTO) {
//                    val uri = intent.data
                val bitmap: Bitmap? = BitmapFactory.decodeFile(currentPhotoPath)
                btn_captureImg.setImageBitmap(bitmap)
//                        Log.d(TAG, bitmap.toString())
            }

        }
    }

    private fun dispatchTakePictureIntent() {
        Intent(ACTION_IMAGE_CAPTURE).also { takePictureIntent ->
            // Ensure that there's a camera activity to handle the intent
            takePictureIntent.resolveActivity(packageManager)?.also {
                // Create the File where the photo should go
                val photoFile: File? = try {
                    createImageFile()
                } catch (ex: IOException) {
                    // Error occurred while creating the File
                    Toast.makeText(
                        applicationContext,
                        "Counldn't create/take picture",
                        Toast.LENGTH_LONG
                    ).show()
                    null
                }
                // Continue only if the File was successfully created
                photoFile?.also { it ->
                    val photoURI: Uri = FileProvider.getUriForFile(
                        this,
                        "com.sudeshi.iorgkt.fileprovider",
                        it
                    )
                    takePictureIntent.putExtra(EXTRA_OUTPUT, photoURI)
                    startActivityForResult(takePictureIntent, REQUEST_TAKE_PHOTO)
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
            // Save a file: path for use with ACTION_VIEW intents
            currentPhotoPath = absolutePath
        }
    }

    override fun onStart() {
        super.onStart()
        outlinedTextCalander.editTextCalander.setOnClickListener {
            datePickerJob = uiScope.launch {
                dateViewModel.setNewDateTime(openDateTimePicker())
//                data.setNewDateTime(context?.openDateTimePicker())
//setNewDateTime is a setValue in a MutableLiveData
            }
        }

    }

    override fun onStop() {
        super.onStop()
        outlinedTextCalander.editTextCalander.setOnClickListener(null)
        datePickerJob?.cancel()
    }

}
