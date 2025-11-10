// ServerBeats v1.1.0 by SEYA CODING
let ytPlayer = null;
let playingUrl = null;
let localMultiplier = 0.6;
let globalVolume = 0.6;
let allowVolume = true;

window.addEventListener('message', (event) => {
    const d = event.data;
    if (d.action === 'open') {
        document.getElementById('serverName').innerText = d.serverName || 'FiveM Server';
        localMultiplier = d.defaultVolume || 0.6;
        document.getElementById('localVol').value = Math.round(localMultiplier * 100);
        document.getElementById('volLabel').innerText = Math.round(localMultiplier * 100) + '%';
        allowVolume = d.allowVolume;
        document.getElementById('playerControls').style.display = allowVolume ? 'block' : 'none';
    } else if (d.action === 'play') {
        playUrl(d.url, d.globalVolume || 0.6);
    } else if (d.action === 'stop') {
        stopPlayback();
    } else if (d.action === 'setLocalVolume') {
        localMultiplier = d.localVolume || localMultiplier;
        applyVolume();
    }
});

document.getElementById('closeBtn').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/close`, {method:'POST',body:'{}'});
    document.getElementById('wrapper').style.display='none';
});

document.getElementById('playBtn').addEventListener('click', () => {
    const url = document.getElementById('yturl').value.trim();
    const vol = document.getElementById('ownerVolume').value/100;
    fetch(`https://${GetParentResourceName()}/ownerPlay`, {method:'POST',body:JSON.stringify({url:url,volume:vol})});
});

document.getElementById('stopBtn').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/ownerStop`, {method:'POST',body:'{}'});
});

document.getElementById('localVol').addEventListener('input', (e)=>{
    localMultiplier = e.target.value/100;
    document.getElementById('volLabel').innerText = Math.round(localMultiplier*100)+'%';
    fetch(`https://${GetParentResourceName()}/setLocalVolume`, {method:'POST',body:JSON.stringify({volume:localMultiplier})});
    applyVolume();
});

function extractVideoId(url){
    try{
        const u=new URL(url);
        if(u.hostname.includes('youtube.com'))return u.searchParams.get('v');
        if(u.hostname==='youtu.be')return u.pathname.slice(1);
    }catch(e){
        const m=url.match(/(?:v=|\/)([0-9A-Za-z_-]{11})/);
        return m?m[1]:null;
    }
    return null;
}
function createPlayer(){
    if(ytPlayer)return;
    const div=document.createElement('div');div.id='ytplayer';div.style.display='none';document.body.appendChild(div);
    ytPlayer=new YT.Player('ytplayer',{height:'0',width:'0',events:{onReady:(e)=>e.target.setVolume(100)}});
}
function playUrl(url,gVol){
    globalVolume=gVol||0.6;
    const vid=extractVideoId(url);
    if(!vid){alert('Invalid YouTube URL');return;}
    if(!window.YT||!YT.Player){const s=document.createElement('script');s.src='https://www.youtube.com/iframe_api';document.head.appendChild(s);window.onYouTubeIframeAPIReady=()=>{createPlayer();loadVideo(vid);};}
    else{createPlayer();loadVideo(vid);}
}
function loadVideo(vid){if(!ytPlayer)return;ytPlayer.loadVideoById(vid);applyVolume();}
function stopPlayback(){if(ytPlayer)try{ytPlayer.stopVideo();}catch(e){}}
function applyVolume(){if(!ytPlayer)return;try{ytPlayer.setVolume(Math.round(globalVolume*localMultiplier*100));}catch(e){}}
