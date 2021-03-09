let isValid = true

const fetch = require('node-fetch')
const config = require('./CONFIG.json').LOCAL
const stockOperations = require('./STOCKOPERATION_DATA_2.json')

console.info('STARTING THE TESTING OPERATIONS')

let apiCall = (iteration) => {
    return Array(1)
        .fill()
        .map(async (el, key) => {
            let globalIteration = key + 1 + iteration
            console.info('iteration: ', globalIteration)
            console.time(`iteration-${globalIteration}`)
            // stockOperations.localKey = `36-634237460.46589444${globalIteration}`
            let url = `${config.api}gatewayAP/PointOfSell/CalendarDayEntity/${config.calendarDayEntityId}/push/operations?isV2=true`
            let response = await fetch(url, {
                method: 'POST',
                headers: config.headers,
                body: JSON.stringify(stockOperations),
            })
            console.timeEnd(`iteration-${globalIteration}`)
            console.info('[RESPONSE] STATUS', response.status)
            if (response.status != 200) isValid = false
            return response
        })
}

;(async () => {
    console.time(`script-run-time`)
    for (let i = 0; i < 1; i++) await Promise.all(apiCall(i))
    if (isValid) console.info('isValid: true')
    else console.info('isValid: false')
    console.timeEnd(`script-run-time`)
    console.info('FINISHED THE TESTING OPERATIONS')
})()
