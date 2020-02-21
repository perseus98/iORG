package com.sudeshi.iorg.model;

import java.io.Serializable;

public class DataModel implements Serializable {
    private int id;
    private String name;
    private String pic_path;
    private String date;
    private int priority;
    private long tag_id;


    public DataModel(int id, String name, String pic_path, String date, int priority) {
        this.id = id;
        this.name = name;
        this.pic_path = pic_path;
        this.date = date;
        this.priority = priority;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPic_path() {
        return pic_path;
    }

    public void setPic_path(String pic_path) {
        this.pic_path = pic_path;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public long getTag_id() {
        return tag_id;
    }

    public void setTag_id(long tag_id) {
        this.tag_id = tag_id;
    }
}
