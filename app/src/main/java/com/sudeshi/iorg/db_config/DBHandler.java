package com.sudeshi.iorg.db_config;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import com.sudeshi.iorg.model.DataModel;
import com.sudeshi.iorg.model.MapTagModel;
import com.sudeshi.iorg.model.TagModel;

import java.util.ArrayList;
import java.util.List;

public class DBHandler extends SQLiteOpenHelper {

    private static final int DATABASE_VERSION = 1;
    private static final String DATABASE_NAME = "iorg_db";

    public DBHandler(@Nullable Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        SQLiteDatabase db = this.getWritableDatabase();
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(createTableTag());
        db.execSQL(createTableData());
        db.execSQL(createMapTable());
        db.execSQL(initTableTag());

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

        db.execSQL(createTableTag());
        db.execSQL(createTableData());
        db.execSQL(createMapTable());
        db.execSQL(initTableTag());

        onCreate(db);
    }

    private String createTableTag() {
        return " CREATE TABLE \"tag_tbl\" (\n" +
                "\t\"id\"\tINTEGER PRIMARY KEY AUTOINCREMENT,\n" +
                "\t\"name\"\tTEXT UNIQUE,\n" +
                "\t\"del_flag\"\tINTEGER DEFAULT 0\n" +
                ")";
    }

    //Tag = id,tag_nm, del_flag
//Data = id,name,pic_path,date,priority
//Map = id, tag_id, data_id
    private String initTableTag() {
        return " INSERT INTO \"tag_tbl\" (\"name\") VALUES ('UnCategorized');";
        // INSERT INTO "main"."tag_tbl" ("name") VALUES ('UnCategorized');
    }

    private String createTableData() {
        return " CREATE TABLE \"data_tbl\" (\n" +
                "\t\"id\"\tINTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\n" +
                "\t\"name\"\tTEXT NOT NULL UNIQUE,\n" +
                "\t\"pic_path\"\tTEXT NOT NULL UNIQUE,\n" +
                "\t\"date\"\tTEXT NOT NULL,\n" +
                "\t\"priority\"\tINTEGER NOT NULL DEFAULT 0);";
    }


    private String createMapTable() {
        return "CREATE TABLE \"map_tbl\" (\n" +
                "\t\"id\"\tINTEGER PRIMARY KEY AUTOINCREMENT,\n" +
                "\t\"tag_id\"\tINTEGER,\n" +
                "\t\"data_id\"\tINTEGER\n" +
                ");";
    }

    public long insertTag(String name) {
        long newRowId = 0;
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put("name", name);

        newRowId = db.insert("tag_tbl", null, values);

        // return newRowId != -1;
        return newRowId;
    }

    public List<TagModel> getTagDataList() {

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

    public long insertData(DataModel dataModel) {
        // data_tbl ,
        // id, name, pic_path, date, priority, tag_id

        long newRowId = 0;
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put("name", dataModel.getName());
        values.put("pic_path", dataModel.getPic_path());
        values.put("date", dataModel.getDate());
        values.put("priority", String.valueOf(dataModel.getPriority()));

        newRowId = db.insert("data_tbl", null, values);

        return newRowId;
    }

    public List<DataModel> getDataList() {

        List<DataModel> dataModelList = new ArrayList<>();
        SQLiteDatabase db = getWritableDatabase();
        Cursor data = db.rawQuery("SELECT * FROM data_tbl", null);

        while (data.moveToNext()) {

            dataModelList.add(new DataModel(data.getInt(0),
                    data.getString(1),
                    data.getString(2),
                    data.getString(3),
                    data.getInt(4)
            ));

        }
        return dataModelList;
    }


    public long insertMapTagData(MapTagModel mapTagModel) {
        // data_tbl ,
        // id, name, pic_path, date, priority, tag_id

        long newRowId = 0;
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put("tag_id", mapTagModel.getTag_id());
        values.put("data_id", mapTagModel.getData_id());
        newRowId = db.insert("map_tbl", null, values);

        return newRowId;
    }


    public List<MapTagModel> getMapTagList(String data_id) {

        List<MapTagModel> mapTagModelList = new ArrayList<>();
        SQLiteDatabase db = getWritableDatabase();
        Cursor data = db.rawQuery("SELECT  mt.tag_id,mt.data_id,t.name from map_tbl mt\n" +
                "INNER JOIN tag_tbl t on t.id = mt.tag_id\n" +
                "WHERE mt.data_id = " + data_id + " and t.del_flag = 0 ", null);

        while (data.moveToNext()) {

            mapTagModelList.add(new MapTagModel(data.getInt(0),
                    data.getInt(1),
                    data.getString(2)
            ));

        }
        return mapTagModelList;
    }

//    public void initTagData(){
//        long newRowId = 0;
//        SQLiteDatabase db = this.getWritableDatabase();
//        ContentValues values = new ContentValues();
//        values.put("name", "UnCategorized");
//
////        newRowId =
//        db.insert("tag_tbl", null, values);
//
//        // return newRowId != -1;
////        return newRowId;
//
//    }


}
