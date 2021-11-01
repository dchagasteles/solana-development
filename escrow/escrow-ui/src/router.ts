import { createRouter, createWebHashHistory } from 'vue-router'

const Alice = () => import("./Alice.vue")
const Bob = () => import("./Bob.vue")

export default createRouter({
    history: createWebHashHistory(),
    routes: [
        {
            name: "Alice",
            path: "/",
            component: Alice
        },
        {
            name: "Bob",
            path: "/bob",
            component: Bob
        }
    ]
})
