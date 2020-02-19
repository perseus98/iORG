package com.sudeshi.iorg.db_config;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import com.sudeshi.iorg.activity.model.TagModel;

import java.util.ArrayList;
import java.util.List;

public class DBHandler extends SQLiteOpenHelper {

    // Variables ================================================
    private static final int DATABASE_VERSION = 1;
    private static final String DATABASE_NAME = "iorg_db";

    public DBHandler(@Nullable Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        SQLiteDatabase db = this.getWritableDatabase();
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(createTable());
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

        db.execSQL(createTable());
        onCreate(db);
    }


// Functions ================================================

    private String createTable() {
        return " CREATE TABLE \"tag_tbl\" (\n" +
                "\t\"id\"\tINTEGER PRIMARY KEY AUTOINCREMENT,\n" +
                "\t\"name\"\tTEXT UNIQUE,\n" +
                "\t\"del_flag\"\tINTEGER DEFAULT 0\n" +
                ")";
    }
// == Tbl :: Tag ================================================

    public boolean insertTag(String name) {
        long newRowId = 0;
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put("name", name);

        newRowId = db.insert("tag_tbl", null, values);

        return newRowId != -1;
    }

    public List<TagModel> getTagList() {

        List<TagModel> tagModelList = new ArrayList<>();


        SQLiteDatabase db = getWritableDatabase();
        Cursor data = db.rawQuery("SELECT * FROM tag_tbl WHERE del_flag = 0", null);

        if (data.moveToFirst()) {
            while (data.moveToNext()) {

                tagModelList.add(new TagModel(data.getInt(0),
                        data.getString(1),
                        data.getInt(2)));

            }
        }
        return tagModelList;
    }

    // == Tbl :: Tag ================================================
    public boolean insertData(String name) {
        long newRowId = 0;
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put("name", name);

        newRowId = db.insert("tag_tbl", null, values);

        return newRowId != -1;
    }

    public List<TagModel> getDataList() {

        List<TagModel> tagModelList = new ArrayList<>();


        SQLiteDatabase db = getWritableDatabase();
        Cursor data = db.rawQuery("SELECT * FROM tag_tbl WHERE del_flag = 0", null);

        if (data.moveToFirst()) {
            while (data.moveToNext()) {

                tagModelList.add(new TagModel(data.getInt(0),
                        data.getString(1),
                        data.getInt(2)));

            }
        }
        return tagModelList;
    }


}
