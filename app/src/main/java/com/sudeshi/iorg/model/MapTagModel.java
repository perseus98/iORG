package com.sudeshi.iorg.model;

import java.io.Serializable;

public class MapTagModel implements Serializable {
    private int tag_id;
    private int data_id;
    private String name;

    public MapTagModel(int tag_id, int data_id, String name) {
        this.tag_id = tag_id;
        this.data_id = data_id;
        this.name = name;
    }

    public int getTag_id() {
        return tag_id;
    }

    public void setTag_id(int tag_id) {
        this.tag_id = tag_id;
    }

    public int getData_id() {
        return data_id;
    }

    public void setData_id(int data_id) {
        this.data_id = data_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
