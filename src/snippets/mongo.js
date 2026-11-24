db.listingsAndReviews.aggregate([
    {
        $unwind: "$amenities"

    },
    {$group: {
        _id: "$amenities",
        frecuencia_amenities: {$sum: 1}

    }},
    {
        $sort: {frecuencia_amenities: -1}
    },
    {
        $limit: 5
    }
])
