db.listingsAndReviews.find({
    $and: [
    {accommodates:{$gte: 4}},
    {bathrooms:{$gte: 2}}
    ]  
})


db.listingsAndReviews.aggregate([
    {
    $group: {
        _id:"$property_type",
        precio_promedio: {$avg: "$price" }
    }
}
])

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

