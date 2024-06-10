let serverStopped = false
let reload = undefined
setTimeout(() => {
    document.body.addEventListener('htmx:sendError', function (evt) {
        console.log(`SE ~ evt:`, evt)
        const target = evt.detail.target
        if (target.id === 'hr') {
            serverStopped = true
        }
    })
    document.body.addEventListener('htmx:afterRequest', function (evt) {
        const target = evt.detail.target
        if (target.id === 'hr') {
            if (evt.detail.failed) {
                serverStopped = true
            }
            if (evt.detail.successful) {
                if (serverStopped) {
                    console.log('Server restarted!')
                    serverStopped = false
                    window.location.reload()
                }
            }
        }
    })
}, 150)
