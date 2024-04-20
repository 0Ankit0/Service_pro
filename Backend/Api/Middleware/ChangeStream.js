import { EventEmitter } from 'events';
import { Request } from '../Modals/requests.js';
import { io } from '../index.js';
const eventEmitter = new EventEmitter();

async function setupChangeStream(req, res, next) {//make sure your database is replica set enabled

    const FilterStream = [
        {
            $match: {
                $and: [
                    { "updateDescription.updatedFields.Status": { $exists: true } },
                    { "operationType": "update" }
                ]
            }
        }
    ];

    const changeStream = Request.watch(FilterStream);
    try {
        changeStream.on('change', (data) => {
            eventEmitter.emit('change', data);
        });
        next();
        await closeChangeStream(5000, changeStream);
    } catch (error) {
        console.error("Error occured in change stream", error);
    }
}

eventEmitter.on('change', (data) => {
    console.log('Change detected:', data);
    io.emit('change', data);
});


function closeChangeStream(timeInMs = 10000, changeStream) {
    return new Promise((resolve) => {
        setTimeout(() => {
            console.log("Closing the change stream");
            changeStream.close();
        }, timeInMs);
    })

}
export { setupChangeStream };
