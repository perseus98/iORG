package com.sudeshi.iorgkt.db.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.PrimaryKey

@Entity(
    tableName = "table_map", foreignKeys = [
        ForeignKey(
            entity = Tag::class,
            parentColumns = ["id"],
            childColumns = ["tag_id"],
            onDelete = ForeignKey.CASCADE
        ),
        ForeignKey(
            entity = Data::class,
            parentColumns = ["id"],
            childColumns = ["data_id"],
            onDelete = ForeignKey.CASCADE
        )]
)
data class Map(
    //Map = id, tag_id, data_id
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    val id: Int,
    @ColumnInfo(name = "tag_id")
    val tag_id: Int,
    @ColumnInfo(name = "data_id")
    val data_id: Int
)