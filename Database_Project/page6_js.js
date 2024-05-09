window.onload = function() {
    const user = JSON.parse(localStorage.getItem('user'));
    console.log(user);
    if (!user) {
        // If the user is not logged in, redirect them to the login page
        window.location.href = '/login.html';
    }

    // Load user-specific data
    // ...
};



document.addEventListener('DOMContentLoaded', async function () {
    // let table2p2 = document.querySelector("#e");
    // function isNumber(value) {
    //     return !isNaN(value);
    // }
    const user = JSON.parse(localStorage.getItem('user'));
    let payl = {"User":user}
    payl = JSON.stringify(payl);
    let Res = await fetch('http://localhost:3000/getdatapage6', {
        method: 'POST',
        mode: 'cors', // no-cors, *cors, same-origin
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'same-origin', // include, *same-origin, omit
        headers: {
            'Content-Type': 'application/json'
        },
        body: payl
    })
    console.log(Res);
    Res =await Res.json();
    console.log(Res)
    if(Res["sucess"]){
        Res = (Res["data"]);
        Res = JSON.parse(Res);
        for (let [key, val] of Object.entries(Res)){
            const ele = document.getElementById(key);
            console.log(ele)
            if(ele!=null) ele.value = val;
            console.log(val);
        }
    }

    const form = document.getElementById('block5');

    //login
    form.addEventListener('submit',async function(e) {
        // Prevent default behavior:
        e.preventDefault();
        //console.log("y");
        // Create payload as new FormData object:
        const formData = new FormData(form);
        console.log(formData);
        let res = Object.fromEntries(formData);
        const user = JSON.parse(localStorage.getItem('user'));
        res["User"] = user;
        console.log(res);
        const payload = JSON.stringify(res);
        for(data of formData){
            console.log(`${data[0]} ${data[1]}`)
        }
        console.log(payload);
        const respo = await fetch('http://localhost:3000/datapage6', {
            method: 'POST',
            mode: 'cors', // no-cors, *cors, same-origin
            cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
            credentials: 'same-origin', // include, *same-origin, omit
            headers: {
                'Content-Type': 'application/json'
            },
            body: payload
        })
        const response = await respo.json()
        // for(const key in response){
        //     var message = response[key]
        // }
        console.log(response["success"])
        
        //if(response["success"]) window.location.href = ('http://127.0.0.1:5500/page2.html') 
        if(response["success"]) window.location.href = ("/page7.html")
    })
    const logoutbtn = document.querySelector(".next-page-button");
    logoutbtn.addEventListener('click',function (){
        localStorage.removeItem('user');

        // Redirect to the login page:
        window.location.href = '/login.html';
    })
});


