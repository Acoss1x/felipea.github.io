db.listingsAndReviews.insertOne({ 
    name: "Cozy Cabin Retreat",
    summary: "Buena habitacion",
    property_type: "Cabin",
    price: 150
});

db.listingsAndReviews.insertOne({
    name: "Casa munoz",
    address:{
        country: "Chile",
        market: "Santiago",
    }
});

db.listingsAndReviews.insertMany([
    {
        name: "Studio de Arte Urbano",
        price: 80
    },
    {
        name: "Loft Minimalista",
        price: 110
    }
]);

db.listingsAndReviews.insertMany([
    {
        name: "Apartamento munoz",
        price: 670,
        amenities: ["piscina", "gimnasio", "jacuzzi"]
    }

]);

db.listingsAndReviews.insertOne({
    name: "Casa de Playa",
    _id: ObjectId('6ae11aa3c5722858f71acd7b')
});

db.listingsAndReviews.find(
    { 
        "address.country": "Brazil"
    },
    {
        name: 1,
        price: 1
    }
)

db.listingsAndReviews.find(
    {
        beds: { $gt: 5 }
    },
    {
        name: 1,
        number_of_reviews: 1
    }
)

db.listingsAndReviews.find(
    {
        price: { $lt: 75 }
    },
    {
        name: 1,
        price: 1,
        property_type: 1
    }
)

 db.listingsAndReviews.find({
    $and: [
        {property_type: "Apartment"},
        {"address.market": "New York"}
    ]

});

db.listingsAndReviews.find({
     property_type: { $in: ["House", "Condominium"] } 
});

db.listingsAndReviews.find({
    name: {$regex: "Luxury", $options: "i"}
})

db.listingsAndReviews.find({
    amenities: "Heating"
})

db.listingsAndReviews.find({
    amenities: { $size : 20}
})

db.listingsAndReviews.find(
    {},
    {name: 1, price: 1, "address.country": 1}

).sort({price: -1}).limit(10)

db.listingsAndReviews.find(
    {last_review : null},
    {name: 1, summary: 1, description: 1}

).sort({number_of_reviews: -1})

db.listingsAndReviews.updateOne(
    {name: "Cozy Cabin Retreat"},
    {$set : {property_type: "Entire home/apt"}}
)

db.listingsAndReviews.updateOne(
    {name: "Casa munoz"},
    {
        $set : {property_type: "Habitacion"},
        $push : {amenities: "Smart TV"}
    }
)

db.listingsAndReviews.updateMany(
    {"address.country": "Spain"},
    {
        $inc: {number_of_reviews: 1}
    }
)

db.listingsAndReviews.updateMany(
    {amenities: "Cable TV"},
    {
        $pull: {amenities: "Cable TV"}
    }
)

db.listingsAndReviews.updateOne(
    {name: "Mansion de Prueba"},
    {
        $set: { price: 1500, "address.country" : "United States"}
    },
    {
        upsert: true
    }
)

db.listingsAndReviews.aggregate([
    {$match: { $expr: { $gt: [ { $size: "$amenities" }, 10 ] } } },
    {$count: "listings_mas_10"}
])

db.listingsAndReviews.aggregate([
    {$group: {
        _id: "$address.country",
        precio_promedio: {$avg: "$price"}
    }}
])

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

db.listingsAndReviews.aggregate([
    {
        $match: {property_type: { $exists: true }}
    },
    {
        $group: {
            _id: "$property_type",
            frecuencia_property_type: {$sum: 1}
        }},
    {
        $sort: {frecuencia_property_type: -1}
    }

])

db.listingsAndReviews.aggregate([
    {
        $project: {
            name: 1,
            price: 1,
            price_entero: { $toInt: "$price" }
        }
    }
])

db.listingsAndReviews.aggregate([
    {
        $match: { number_of_reviews: { $gte: 10 } }
    },
    {
        $group: {
            _id: null,
            promedio_rating: { $avg: "$review_scores.review_scores_rating" }
        }
    }
])

db.listingsAndReviews.aggregate([
    {
        $bucket: {
            groupBy: "$price",
            boundaries: [0, 101, 301, 1001],
            default: "1000+",
            output: {
                cantidad_listings: { $sum: 1 }
            }
        }
    }
])

db.listingsAndReviews.aggregate([
    {
        $lookup: {
            from: "hosts",
            localField: "host.host_id",
            foreignField: "host_id",
            as: "informacion_anfitrion"
        }
    }
])

db.listingsAndReviews.aggregate([
    {
        $group: {
            _id: "$address.country",
            promedio_accomodates: { $avg: "$accommodates"}

        }
    },
    {

        $sort: {
            promedio_accomodates: -1
        }
    }
])

db.listingsAndReviews.aggregate([
    {
        $match: {
            last_review: { $exists: true, $ne: null }
        }
    },
    {
        $group: {
            _id: { $year: "$last_review" },
            cantidad_listings: { $sum: 1 }
        }
    },
    {
        $sort: { _id: 1 }
    }
])