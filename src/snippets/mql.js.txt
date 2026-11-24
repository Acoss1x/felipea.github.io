db.listingsAndReviews.aggregate([
     {
        $group: {
            _id: "$host.host_id",
            total_alojamientos: {$sum : 1}
        }
    },
    {
        $sort: {
            total_alojamientos: -1
        }
    },
        {
        $limit: 5
        }
])

