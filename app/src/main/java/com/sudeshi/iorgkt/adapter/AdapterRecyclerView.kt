package com.sudeshi.iorgkt.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.sudeshi.iorgkt.R

class AdapterRecyclerView : RecyclerView.Adapter<AdapterRecyclerView.ViewHolder>() {
    private val titles = arrayOf(
        "Chapter One",
        "Chapter Two", "Chapter Three", "Chapter Four",
        "Chapter Five", "Chapter Six", "Chapter Seven",
        "Chapter Eight"
    )

    private val details = arrayOf(
        "Item one details", "Item two details",
        "Item three details", "Item four details",
        "Item file details", "Item six details",
        "Item seven details", "Item eight details"
    )

    private val images = intArrayOf(
        R.drawable.ic_add_a_photo_black_100dp,
        R.drawable.ic_add_a_photo_black_100dp,
        R.drawable.ic_add_a_photo_black_100dp,
        R.drawable.ic_add_a_photo_black_100dp,
        R.drawable.ic_add_a_photo_black_100dp,
        R.drawable.ic_add_a_photo_black_100dp,
        R.drawable.ic_add_a_photo_black_100dp,
        R.drawable.ic_add_a_photo_black_100dp
    )

    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var itemImage: ImageView
        var itemTitle: TextView
        var itemDetail: TextView

        init {
            itemImage = itemView.findViewById(R.id.card_view_item_image)
            itemTitle = itemView.findViewById(R.id.card_view_item_title)
            itemDetail = itemView.findViewById(R.id.card_view_item_detail)
        }
    }

    override fun onCreateViewHolder(viewGroup: ViewGroup, i: Int): ViewHolder {
        val v = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.layout_cards, viewGroup, false)
        return ViewHolder(v)
    }

    override fun getItemCount(): Int {
        return titles.size
    }

    override fun onBindViewHolder(viewHolder: ViewHolder, i: Int) {
        viewHolder.itemTitle.text = titles[i]
        viewHolder.itemDetail.text = details[i]
        viewHolder.itemImage.setImageResource(images[i])
    }

}