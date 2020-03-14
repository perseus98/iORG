package com.sudeshi.iorgkt.db.model

import androidx.room.*

@Entity(
    tableName = "table_map", foreignKeys = [
        ForeignKey(
            entity = Tag::class,
            parentColumns = ["id"],
            childColumns = ["tag_id"],
            onDelete = ForeignKey.NO_ACTION,
            onUpdate = ForeignKey.NO_ACTION
        ),
        ForeignKey(
            entity = Data::class,
            parentColumns = ["id"],
            childColumns = ["data_id"],
            onDelete = ForeignKey.NO_ACTION,
            onUpdate = ForeignKey.NO_ACTION
        )],
    indices = [Index(value = ["id", "tag_id", "data_id"])]
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