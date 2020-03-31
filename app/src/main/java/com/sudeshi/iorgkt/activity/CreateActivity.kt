package com.sudeshi.iorgkt.activity

import android.annotation.SuppressLint
import android.app.Activity
import android.app.DatePickerDialog
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
import com.google.android.material.snackbar.Snackbar
import com.sudeshi.iorgkt.R.*
import com.sudeshi.iorgkt.R.color.colorWhite
import com.sudeshi.iorgkt.R.style.styledatepicker
import kotlinx.android.synthetic.main.activity_create.*
import kotlinx.android.synthetic.main.activity_create.view.*
import java.io.File
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*


class CreateActivity : AppCompatActivity() {

    private lateinit var currentPhotoPath: String
    private val REQUEST_TAKE_PHOTO = 1
    private val currentTimeStamp: String =
        SimpleDateFormat("yyyyMMddHHmmss", Locale.US).format(Date())
    private val currDateSDF: String =
        SimpleDateFormat("dd/MM/yyyy::HH:mm:ss", Locale.US).format(Date())

//    val TAG: String = "CreateActivity"

    @SuppressLint("SourceLockedOrientationActivity")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(layout.activity_create)
        requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        initContent()
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

    @SuppressLint("SetTextI18n")
    private fun initContent() {
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
        outlinedTextName.editTextName?.setText("NAME = entry_$currentTimeStamp")
        outlinedTextName.editTextName?.setTextColor(getColor(colorWhite))
        outlinedTextCalander.editTextCalander.keyListener = null
        outlinedTextCalander.editTextCalander?.setText("DATE = $currDateSDF")
        outlinedTextCalander.editTextCalander?.setTextColor(getColor(colorWhite))
        initCalander()

        seekBarPriority?.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
                Toast.makeText(
                    applicationContext,
                    "discrete seekbar progress: $progress",
                    Toast.LENGTH_SHORT
                ).show()
            }

            override fun onStartTrackingTouch(seekBar: SeekBar?) {
                Toast.makeText(
                    applicationContext,
                    "discrete seekbar touch started!",
                    Toast.LENGTH_SHORT
                ).show()
            }

            override fun onStopTrackingTouch(seekBar: SeekBar?) {
                Toast.makeText(
                    applicationContext,
                    "discrete seekbar touch stopped",
                    Toast.LENGTH_SHORT
                ).show()
            }
        })
//        code for chips

        btnBack.setOnClickListener {
            startActivity(Intent(this, MainActivity::class.java))
        }
        btnCreate.setOnClickListener {
//            startActivity(Intent(this,Dashboard::class.java))
            Snackbar.make(btnCreate, string.btnClickExample, Snackbar.LENGTH_LONG).setAction(
                string.snackBarBtn
            ) { startActivity(Intent(this, MainActivity::class.java)) }.show()
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

    @SuppressLint("SetTextI18n")
    private fun initCalander() {
        val cal = Calendar.getInstance()
        val dateSetListener =
            DatePickerDialog.OnDateSetListener { _, year, monthOfYear, dayOfMonth ->
                cal.set(Calendar.YEAR, year)
                cal.set(Calendar.MONTH, monthOfYear)
                cal.set(Calendar.DAY_OF_MONTH, dayOfMonth)

                val myFormat = "dd/MM/yyyy, HH:mm:ss" // mention the format you need
                val sdf = SimpleDateFormat(myFormat, Locale.US)
                val dt = sdf.format(cal.time)
                outlinedTextCalander.editTextCalander?.setText("DATE = $dt")
            }

        outlinedTextCalander.editTextCalander.setOnClickListener {
            DatePickerDialog(
                this@CreateActivity, styledatepicker, dateSetListener,
                cal.get(Calendar.YEAR),
                cal.get(Calendar.MONTH),
                cal.get(Calendar.DAY_OF_MONTH)
            ).show()
        }
    }

    private fun initChipGroup() {
//        chip.isClickable = true
//        chip.isCheckable = false
    }

}