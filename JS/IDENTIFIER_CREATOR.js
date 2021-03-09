fs = require('fs');

let identifiers = [{
    "HASH": "03b1fb5d2bdf59deb460c4023b9ba093",
    "DATABASE_IDENTIFIER": "Medical"
}, {
    "HASH": "16b7f34e85105d6e855a8f064c67b789",
    "DATABASE_IDENTIFIER": "PrecisionTest"
}, {
    "HASH": "1cfe9d5198cc48e8bc361c403ac6b596",
    "DATABASE_IDENTIFIER": "Pastry"
}, {
    "HASH": "22e7b8554c075b449a601b64232118e7",
    "DATABASE_IDENTIFIER": "NewBreak"
}, {
    "HASH": "309d611f6912525e992dbc878a8d5433",
    "DATABASE_IDENTIFIER": "PrecisionTestPastry"
}, {
    "HASH": "3a958c70658f4a2c95addccd601e29b7",
    "DATABASE_IDENTIFIER": "FastFood",
    "IS_OVERLOADED": "1"
}, {
    "HASH": "402C9AE7DF814F1793D65CCBFBBC7738",
    "DATABASE_IDENTIFIER": "Alakhawayn"
}, {
    "HASH": "5D51515ADD9E4003AA2F101E777C2F4F",
    "DATABASE_IDENTIFIER": "Tacosdelyonmarket"
}, {
    "HASH": "62bfda8cff10586f81c99424fd425eb5",
    "DATABASE_IDENTIFIER": "Yacht"
}, {
    "HASH": "6bde7be0f985538a842228f967b7ff99",
    "DATABASE_IDENTIFIER": "Moto"
}, {
    "HASH": "7b75bfe39b1958d1a0ae365dce35edf4",
    "DATABASE_IDENTIFIER": "Geneparamed"
}, {
    "HASH": "89620742E279408BBF4591F1FA39FE3E",
    "DATABASE_IDENTIFIER": "Ashaircare",
    "IS_OVERLOADED": "1"
}, {
    "HASH": "B3B8809FCB1D4CDFA4A73470B60E358A",
    "DATABASE_IDENTIFIER": "Sevea"
}, {
    "HASH": "CE24AB41C0C048F2932D4F7AE7186E9E",
    "DATABASE_IDENTIFIER": "Goodone"
}, {
    "HASH": "D452D2FB4A884DE2B30D5168222B33C8",
    "DATABASE_IDENTIFIER": "Testmedical"
}, {
    "HASH": "b2f494ccda1456498e73d2c7036033ae",
    "DATABASE_IDENTIFIER": "OudMalaki"
}, {
    "HASH": "c3232760a9a0596f9a779db7e3e59ba0",
    "DATABASE_IDENTIFIER": "Arwa"
}, {
    "HASH": "z575843432615131a8a23f0acada4bd1",
    "DATABASE_IDENTIFIER": "Total"
}];

identifiers.forEach(element => {
    fs.writeFile(`${element["HASH"]}.json`, JSON.stringify(element), function (error) {
        if (error) return console.log("wasn't able to write ", error);
    });
});