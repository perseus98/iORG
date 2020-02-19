package com.sudeshi.iorg.activity.model;

import java.io.Serializable;

public class TagModel implements Serializable {
    private int id;
    private String name;
    private int del_flag;

    public TagModel(int id, String name, int del_flag) {
        this.id = id;
        this.name = name;
        this.del_flag = del_flag;
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

    public int getDel_flag() {
        return del_flag;
    }

    public void setDel_flag(int del_flag) {
        this.del_flag = del_flag;
    }
}
