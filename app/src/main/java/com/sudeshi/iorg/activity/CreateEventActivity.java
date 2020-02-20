package com.sudeshi.iorg.activity;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.util.Base64;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.sudeshi.iorg.R;
import com.sudeshi.iorg.adapter.DataItemAdapter;
import com.sudeshi.iorg.adapter.TagSpinnerAdapter;
import com.sudeshi.iorg.db_config.DBHandler;
import com.sudeshi.iorg.model.DataModel;
import com.sudeshi.iorg.model.TagModel;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class CreateEventActivity extends AppCompatActivity {

    private static final int IMAGE_PICK = 1;
    private static final int IMAGE_CAPTURE = 3;
    private ImageButton image_pic;
    private int selection_pic = 0;

    private Spinner spinner_priority;
    private Spinner spinner_tag;

    private DBHandler dbHandler;

    private TextView tv_date;

    private String priority;
    private String tagId;
    private List<TagModel> tagModelList;
    private Button btn_create_data;
    private EditText tv_name;
    private TextView tv_tag_text;
    private ListView list_data_item;


    @Override

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_event);
        dbHandler = new DBHandler(this);
        initView();

    }

    private void initView() {
        image_pic = findViewById(R.id.image_pic);
        spinner_priority = findViewById(R.id.spinner_priority);
        tv_date = findViewById(R.id.tv_date);
        btn_create_data = findViewById(R.id.btn_create_data);
        list_data_item = findViewById(R.id.list_data_item);
        tv_tag_text = findViewById(R.id.tv_tag_text);
        tv_name = findViewById(R.id.tv_name);
        spinner_tag = findViewById(R.id.spinner_tag);
        image_pic.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                selection_pic = 1;
                captureImage();
            }
        });

        setPriority();
        getTagListForSpinner();

        Calendar c = Calendar.getInstance();
        final SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        final Calendar myCalendar = Calendar.getInstance();
        final DatePickerDialog.OnDateSetListener date = new DatePickerDialog.OnDateSetListener() {

            @Override
            public void onDateSet(DatePicker view, int year, int monthOfYear,
                                  int dayOfMonth) {

                myCalendar.set(Calendar.YEAR, year);
                myCalendar.set(Calendar.MONTH, monthOfYear);
                myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                final String formattedDate = df.format(myCalendar.getTime());
                tv_date.setText(formattedDate);
            }

        };

        tv_date.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                new DatePickerDialog(CreateEventActivity.this, date, myCalendar
                        .get(Calendar.YEAR), myCalendar.get(Calendar.MONTH),
                        myCalendar.get(Calendar.DAY_OF_MONTH)).show();
            }
        });

        spinner_tag.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                setTagId(String.valueOf(tagModelList.get(position).getId()));
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        btn_create_data.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                createData();
            }
        });

        getData();
    }

    private void createData() {

        String pic = imageToString(((BitmapDrawable) image_pic.getDrawable()).getBitmap());
        try {
            dbHandler.insertData(new DataModel(0,
                    tv_name.getText().toString().trim(),
                    pic,
                    tv_date.getText().toString().trim(),
                    Integer.parseInt(getPriority()),
                    Integer.parseInt(getTagId())));

            getData();

        } catch (Exception e) {
            Toast.makeText(this, "" +
                    e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    private void captureImage() {
        Intent intent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
        startActivityForResult(intent, IMAGE_CAPTURE);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // check if the request code is same as what is passed  here it is 2

        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case IMAGE_CAPTURE:
                    if (selection_pic == 1)
                        this.imageFromCamera(resultCode, data, image_pic);
                    break;
                default:
                    break;
            }
        }
    }


    private void imageFromCamera(int resultCode, Intent data, ImageButton imageButton) {
        // this.updateImageView((Bitmap) data.getExtras().get("data"), );
        Bitmap photo = (Bitmap) data.getExtras().get("data");
        imageButton.setImageBitmap(photo);
    }

    public String imageToString(Bitmap bmp) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        bmp.compress(Bitmap.CompressFormat.JPEG, 70, baos);
        byte[] imageBytes = baos.toByteArray();
        String encodedImage = Base64.encodeToString(imageBytes, Base64.DEFAULT);
        return encodedImage;
    }

    private void setPriority() {

        // Spinner Drop down elements
        final List<String> priority = new ArrayList<String>();
        priority.add("0");
        priority.add("1");
        priority.add("2");
        priority.add("3");
        priority.add("4");
        priority.add("5");
        // Creating adapter for spinner
        ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, priority);
        // Drop down layout style - list view with radio button
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        // attaching data adapter to spinner
        spinner_priority.setAdapter(dataAdapter);
        spinner_priority.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                setPriority(priority.get(position));
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

    }

    private void getTagListForSpinner() {

        tagModelList = dbHandler.getTagList();
        if (tagModelList.size() > 0) {
            TagSpinnerAdapter adapter = new TagSpinnerAdapter(this, tagModelList);
            spinner_tag.setAdapter(adapter);
            adapter.notifyDataSetChanged();
        }

    }

    public String getTagId() {
        return tagId;
    }

    public void setTagId(String tagId) {
        this.tagId = tagId;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }


    private void getData() {
        List<DataModel> dataModelList = dbHandler.getDataList();
        if (dataModelList.size() > 0) {
            DataItemAdapter adapter = new DataItemAdapter(this, dataModelList);
            list_data_item.setAdapter(adapter);
            adapter.notifyDataSetChanged();
        }
    }

}
