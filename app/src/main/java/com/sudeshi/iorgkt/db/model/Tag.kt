package com.sudeshi.iorgkt.db.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.Index
import androidx.room.PrimaryKey

@Entity(tableName = "table_tag", indices = [Index(value = ["id"])])
data class Tag(
    //Tag = id,tag_nm, del_flag
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    val id: Int,
    @ColumnInfo(name = "name")
    val name: String,
    @ColumnInfo(name = "del_flag", defaultValue = "false")
    val del_flag: Boolean
)