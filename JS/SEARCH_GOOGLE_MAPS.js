let places = [
    {
        TypeS_Fichier: 'CADO',
        Spécialité: 'Accessoires & Habillement',
        'Nom/enseigne': 'TIKI',
        Adresse: 'PARC D ACTIVITE MARJANE KM ROUTE DES FACULTES',
        Quartier: '',
        Ville: 'MOHAMMEDIA',
    },
    {
        TypeS_Fichier: 'CADO',
        Spécialité: 'Accessoires & Habillement',
        'Nom/enseigne': 'DIAMANTINE',
        Adresse: 'BOUTIQUE N BR 12 MARJANE',
        Quartier: '',
        Ville: 'SALE',
    },
    {
        TypeS_Fichier: 'CADO',
        Spécialité: 'Café, Restaurant & Patisserie',
        'Nom/enseigne': "MC DONALD'S",
        Adresse: 'CENTRE COMMERCIAL MARJANE ROUTE NATIONALE 1',
        Quartier: 'CHARF SOUANI',
        Ville: 'TANGER',
    },
    {
        TypeS_Fichier: 'CADO',
        Spécialité: 'Ameublement, Décoration & Accessoires de Maison',
        'Nom/enseigne': 'MOBILIA',
        Adresse: 'CENTRE COMMERCIAL ACIMA BOULEVARD HASSAN II',
        Quartier: '',
        Ville: 'TEMARA',
    },
]

const googleMapsClient = require('@google/maps').createClient({
    key: 'AIzaSyBbSugFoLmiYME0qA6tM5fR3L7XNKwoyaI',
})

const getAddress = (address) => {
    return new Promise((resolve, reject) => {
        googleMapsClient.geocode({ address: address }, (err, response) => {
            if (
                !err &&
                response.json &&
                response.json.results &&
                response.json.results.geometry
            ) {
                setTimeout(() => {
                    resolve(response.json.results[0].geometry.location)
                }, 1000)
            } else {
                reject(status)
            }
        })
    })
}

const getAddressWithCallback = (address, callback = () => {}) => {
    googleMapsClient.geocode({ address: address }, (err, response) => {
        if (!err && response.json.results.length > 0) {
            setTimeout(() => {
                let postalCode = response.json.results[0].address_components.find(
                    (el) => el.types.includes('postal_code')
                )
                callback(
                    response.json.results[0].geometry.location,
                    postalCode && postalCode.short_name
                        ? postalCode.short_name
                        : 0
                )
            }, 1000)
        } else {
            // console.error('address not found', address)
            // console.error('error', err)
        }
    })
}

places.forEach((el) => {
    return getAddressWithCallback(
        `${el['Adresse']}`,
        (geoLocation, postcode) => {
            console.log(
                JSON.stringify({
                    ...el,
                    postcode: postcode,
                    latitude: geoLocation ? geoLocation.lat : '---',
                    longitude: geoLocation ? geoLocation.lng : '---',
                })
            )
        }
    )
})
