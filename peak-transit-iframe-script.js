

(() => {

    // Champlain College Peak Transit iFrame Map Implementation Adjustments

    const params = new URLSearchParams(document.location.search);
    const iframe = params.get("iframe");
    if (!iframe) return;

    document.getElementById("sidebar").style.display = 'none';
    document.getElementById("main-header").style.display = 'none';
    document.getElementById("map").style.top = 0;
    document.getElementById("map").style.bottom = 0;
    document.getElementById("map").style.height = "100%";

    const setZoom = () => {
        const vh = document.documentElement.clientHeight;
        let zl = 16;
        for (const z of [[365,14],[440,14.5],[510,14.75],[607,15],[720,15.25],[852,15.5],[1024,15.75]]) {
            if (vh < z[0]) {
                zl = z[1];
                break;
            }
        }
        map.setZoom(zl);
    };

    window.onresize = setZoom;
    setZoom();
    map.controls[google.maps.ControlPosition.TOP_CENTER].removeAt(0);

})();

