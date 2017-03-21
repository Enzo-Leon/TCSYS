var test = function(item) {
    localStorage.setItem("Active", item);
    console.log("Local");
    console.log(window.localStorage);
    console.log('==================================');
    console.log(localStorage.getItem("Active"));
};