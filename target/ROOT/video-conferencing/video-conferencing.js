// Make sure to install the necessary dependencies
const { CallClient, VideoStreamRenderer, LocalVideoStream } = require('@azure/communication-calling');
const { AzureCommunicationTokenCredential } = require('@azure/communication-common');
const { AzureLogger, setLogLevel } = require("@azure/logger");
require('@tensorflow/tfjs-backend-cpu');
require('@tensorflow/tfjs-backend-webgl');
const cocoSsd = require('@tensorflow-models/coco-ssd');
const { jsPDF } = require("jspdf");
const { autoTable } = require("jspdf-autotable");

// Load the model
let loadingOverlay = document.getElementById('loading-overlay');
LoadModel = async () => {
    try {
        return await cocoSsd.load();
    } finally {
        loadingOverlay.hidden = true;
    }
}
const modelPreload = LoadModel();

// Set the log level and output
setLogLevel('verbose');
AzureLogger.log = (...args) => {
    console.log(...args);
};

// Calling web sdk objects
let callAgent;
let deviceManager;
let call;
let incomingCall;
let localVideoStream;
let localVideoStreamRenderer;

// UI widgets
//let userAccessToken = document.getElementById('user-access-token');
let calleeAcsUserId = document.getElementById('callee-acs-user-id');
let initializeCallAgentButton = document.getElementById('initialize-call-agent');
let startCallButton = document.getElementById('start-call-button');
let hangUpCallButton = document.getElementById('hangup-call-button');
let acceptCallButton = document.getElementById('accept-call-button');
let startVideoButton = document.getElementById('start-video-button');
let stopVideoButton = document.getElementById('stop-video-button');
let connectedLabel = document.getElementById('connectedLabel');
let remoteVideosGallery = document.getElementById('remoteVideosGallery');
let localVideoContainer = document.getElementById('localVideoContainer');
let copyIdButton = document.getElementById('copy-id');
let objectDetectingButton = document.getElementById('object-detecting-button');
let objectDetectionLabel = document.getElementById('objectDetectionLabel');
const canvas = document.getElementById("object-detecting-canvas");
let notesLabel = document.getElementById('notesLabel');
let evidenceNotesInput = document.getElementById('evidence-notes');
let saveButton = document.getElementById('save-button');
let docName =  document.getElementById('doc-name');
let lastDetections = [];

/**
 * Using the CallClient, initialize a CallAgent instance with a CommunicationUserCredential which will enable us to make outgoing calls and receive incoming calls. 
 * You can then use the CallClient.getDeviceManager() API instance to get the DeviceManager.
 */
initializeCallAgentButton.onclick = async () => {
    try {
        const callClient = new CallClient(); 
        // Automation of Communication Tokens
        const res = await fetch('/api/token');
        const { userId, token } = await res.json();
        let userAccessToken = token;
        document.getElementById('my-user-id').value = userId;
        //document.getElementById('user-access-token').value = userAccessToken;
        tokenCredential = new AzureCommunicationTokenCredential(userAccessToken);
        // userAccessToken.value.trim() if input
        callAgent = await callClient.createCallAgent(tokenCredential)
        // Set up a camera device to use.
        deviceManager = await callClient.getDeviceManager();
        await deviceManager.askDevicePermission({ video: true });
        await deviceManager.askDevicePermission({ audio: true });
        // Listen for an incoming call to accept.
        callAgent.on('incomingCall', async (args) => {
            try {
                incomingCall = args.incomingCall;
                acceptCallButton.disabled = false;
                startCallButton.disabled = true;
            } catch (error) {
                console.error(error);
            }
        });

        startCallButton.disabled = false;
        initializeCallAgentButton.disabled = true;
    } catch(error) {
        console.error(error);
    }
}

/**
 * Place a 1:1 outgoing video call to a user
 * Add an event listener to initiate a call when the `startCallButton` is clicked:
 * First you have to enumerate local cameras using the deviceManager `getCameraList` API.
 * In this quickstart we're using the first camera in the collection. Once the desired camera is selected, a
 * LocalVideoStream instance will be constructed and passed within `videoOptions` as an item within the
 * localVideoStream array to the call method. Once your call connects it will automatically start sending a video stream to the other participant. 
 */
startCallButton.onclick = async () => {
    try {
        const localVideoStream = await createLocalVideoStream();
        const videoOptions = localVideoStream ? { localVideoStreams: [localVideoStream] } : undefined;
        call = callAgent.startCall([{ communicationUserId: calleeAcsUserId.value.trim() }], { videoOptions });
        // Subscribe to the call's properties and events.
        subscribeToCall(call);
    } catch (error) {
        console.error(error);
    }
}

/**
 * Accepting an incoming call with video
 * Add an event listener to accept a call when the `acceptCallButton` is clicked:
 * After subscribing to the `CallAgent.on('incomingCall')` event, you can accept the incoming call.
 * You can pass the local video stream which you want to use to accept the call with.
 */
acceptCallButton.onclick = async () => {
    try {
        const localVideoStream = await createLocalVideoStream();
        const videoOptions = localVideoStream ? { localVideoStreams: [localVideoStream] } : undefined;
        call = await incomingCall.accept({ videoOptions });
        // Subscribe to the call's properties and events.
        subscribeToCall(call);
    } catch (error) {
        console.error(error);
    }
}

/**
 * Subscribe to a call obj.
 * Listen for property changes and collection updates.
 */
function subscribeToCall(call) {
    try {
        // Inspect the initial call.id value.
        console.log(`Call Id: ${call.id}`);
        //Subscribe to call's 'idChanged' event for value changes.
        call.on('idChanged', () => {
            console.log(`Call Id changed: ${call.id}`); 
        });

        // Inspect the initial call.state value.
        console.log(`Call state: ${call.state}`);
        // Subscribe to call's 'stateChanged' event for value changes.
        call.on('stateChanged', async () => {
            console.log(`Call state changed: ${call.state}`);
            if(call.state === 'Connected') {
                connectedLabel.hidden = false;
                acceptCallButton.disabled = true;
                startCallButton.disabled = true;
                hangUpCallButton.disabled = false;
                startVideoButton.disabled = false;
                stopVideoButton.disabled = false;
                remoteVideosGallery.hidden = false;
                objectDetectingButton.hidden = false;
                saveButton.hidden = false;
                docName.hidden = false;
                evidenceNotesInput.hidden = false;
                notesLabel.hidden = false;
            } else if (call.state === 'Disconnected') {
                connectedLabel.hidden = true;
                startCallButton.disabled = false;
                hangUpCallButton.disabled = true;
                startVideoButton.disabled = true;
                stopVideoButton.disabled = true;
                remoteVideosGallery.hidden = true;
                objectDetectingButton.hidden = true;
                console.log(`Call ended, call end reason={code=${call.callEndReason.code}, subCode=${call.callEndReason.subCode}}`);
            }   
        });

        call.on('isLocalVideoStartedChanged', () => {
            console.log(`isLocalVideoStarted changed: ${call.isLocalVideoStarted}`);
        });
        console.log(`isLocalVideoStarted: ${call.isLocalVideoStarted}`);
        call.localVideoStreams.forEach(async (lvs) => {
            localVideoStream = lvs;
            await displayLocalVideoStream();
        });
        call.on('localVideoStreamsUpdated', e => {
            e.added.forEach(async (lvs) => {
                localVideoStream = lvs;
                await displayLocalVideoStream();
            });
            e.removed.forEach(lvs => {
               removeLocalVideoStream();
            });
        });
        
        // Inspect the call's current remote participants and subscribe to them.
        call.remoteParticipants.forEach(remoteParticipant => {
            subscribeToRemoteParticipant(remoteParticipant);
        });
        // Subscribe to the call's 'remoteParticipantsUpdated' event to be
        // notified when new participants are added to the call or removed from the call.
        call.on('remoteParticipantsUpdated', e => {
            // Subscribe to new remote participants that are added to the call.
            e.added.forEach(remoteParticipant => {
                subscribeToRemoteParticipant(remoteParticipant)
            });
            // Unsubscribe from participants that are removed from the call
            e.removed.forEach(remoteParticipant => {
                console.log('Remote participant removed from the call.');
            });
        });
    } catch (error) {
        console.error(error);
    }
}

/**
 * Subscribe to a remote participant obj.
 * Listen for property changes and collection updates.
 */
subscribeToRemoteParticipant = (remoteParticipant) => {
    try {
        // Inspect the initial remoteParticipant.state value.
        console.log(`Remote participant state: ${remoteParticipant.state}`);
        // Subscribe to remoteParticipant's 'stateChanged' event for value changes.
        remoteParticipant.on('stateChanged', () => {
            console.log(`Remote participant state changed: ${remoteParticipant.state}`);
        });

        // Inspect the remoteParticipants's current videoStreams and subscribe to them.
        remoteParticipant.videoStreams.forEach(remoteVideoStream => {
            subscribeToRemoteVideoStream(remoteVideoStream)
        });
        // Subscribe to the remoteParticipant's 'videoStreamsUpdated' event to be
        // notified when the remoteParticipant adds new videoStreams and removes video streams.
        remoteParticipant.on('videoStreamsUpdated', e => {
            // Subscribe to new remote participant's video streams that were added.
            e.added.forEach(remoteVideoStream => {
                subscribeToRemoteVideoStream(remoteVideoStream)
            });
            // Unsubscribe from remote participant's video streams that were removed.
            e.removed.forEach(remoteVideoStream => {
                console.log('Remote participant video stream was removed.');
            })
        });
    } catch (error) {
        console.error(error);
    }
}

/**
 * Subscribe to a remote participant's remote video stream obj.
 * You have to subscribe to the 'isAvailableChanged' event to render the remoteVideoStream. If the 'isAvailable' property
 * changes to 'true', a remote participant is sending a stream. Whenever availability of a remote stream changes
 * you can choose to destroy the whole 'Renderer', a specific 'RendererView' or keep them, but this will result in displaying blank video frame.
 */
subscribeToRemoteVideoStream = async (remoteVideoStream) => {
    let renderer = new VideoStreamRenderer(remoteVideoStream);
    let view;
    let remoteVideoContainer = document.createElement('div');
    remoteVideoContainer.className = 'remote-video-container';

    let loadingSpinner = document.createElement('div');
    loadingSpinner.className = 'loading-spinner';
    remoteVideoStream.on('isReceivingChanged', () => {
        try {
            if (remoteVideoStream.isAvailable) {
                const isReceiving = remoteVideoStream.isReceiving;
                const isLoadingSpinnerActive = remoteVideoContainer.contains(loadingSpinner);
                if (!isReceiving && !isLoadingSpinnerActive) {
                    remoteVideoContainer.appendChild(loadingSpinner);
                } else if (isReceiving && isLoadingSpinnerActive) {
                    remoteVideoContainer.removeChild(loadingSpinner);
                }
            }
        } catch (e) {
            console.error(e);
        }
    });

    const createView = async () => {
        // Create a renderer view for the remote video stream.
        view = await renderer.createView();
        // Attach the renderer view to the UI.
        remoteVideoContainer.appendChild(view.target);
        remoteVideosGallery.appendChild(remoteVideoContainer);
    }

    // Remote participant has switched video on/off
    remoteVideoStream.on('isAvailableChanged', async () => {
        try {
            if (remoteVideoStream.isAvailable) {
                await createView();
            } else {
                view.dispose();
                remoteVideosGallery.removeChild(remoteVideoContainer);
            }
        } catch (e) {
            console.error(e);
        }
    });

    // Remote participant has video on initially.
    if (remoteVideoStream.isAvailable) {
        try {
            await createView();
        } catch (e) {
            console.error(e);
        }
    }
}

/**
 * Start your local video stream.
 * This will send your local video stream to remote participants so they can view it.
 */
startVideoButton.onclick = async () => {
    try {
        const localVideoStream = await createLocalVideoStream();
        await call.startVideo(localVideoStream);
    } catch (error) {
        console.error(error);
    }
}

/**
 * Stop your local video stream.
 * This will stop your local video stream from being sent to remote participants.
 */
stopVideoButton.onclick = async () => {
    try {
        await call.stopVideo(localVideoStream);
    } catch (error) {
        console.error(error);
    }
}

/**
 * To render a LocalVideoStream, you need to create a new instance of VideoStreamRenderer, and then
 * create a new VideoStreamRendererView instance using the asynchronous createView() method.
 * You may then attach view.target to any UI element. 
 */
createLocalVideoStream = async () => {
    const camera = (await deviceManager.getCameras())[0];
    if (camera) {
        return new LocalVideoStream(camera);
    } else {
        console.error(`No camera device found on the system`);
    }
}

/**
 * Display your local video stream preview in your UI
 */
displayLocalVideoStream = async () => {
    try {
        localVideoStreamRenderer = new VideoStreamRenderer(localVideoStream);
        const view = await localVideoStreamRenderer.createView();
        localVideoContainer.hidden = false;
        localVideoContainer.appendChild(view.target);
    } catch (error) {
        console.error(error);
    } 
}

/**
 * Remove your local video stream preview from your UI
 */
removeLocalVideoStream = async() => {
    try {
        localVideoStreamRenderer.dispose();
        localVideoContainer.hidden = true;
    } catch (error) {
        console.error(error);
    } 
}

/**
 * End current call
 */
hangUpCallButton.addEventListener("click", async () => {
    // end the current call
    await call.hangUp();
});

/**
 * Copy the generated user ID for calling
 */
copyIdButton.addEventListener('click', async () => {
    // copy user ID to clipboard
    navigator.clipboard.writeText(document.getElementById('my-user-id').value);
});

/**
 * Perform object detection count on remote video stream
 */
objectDetectingButton.addEventListener('click', async () => {
    const video = remoteVideosGallery.querySelector('.remote-video-container video');
    if (!video || video.readyState < 2) {
        console.log('Remote video not ready');
        return;
    }

    const frame = document.createElement('canvas');
    frame.width = video.clientWidth;
    frame.height = video.clientHeight;
    frame.getContext('2d').drawImage(video, 0, 0, video.clientWidth, video.clientHeight);

    let model = await modelPreload;
    const predictions = await model.detect(frame);
    console.log('Predictions:', predictions);

    canvas.width  = video.clientWidth;
    canvas.height = video.clientHeight;
    
    const font = "16px sans-serif";
    const textHeight = parseInt(font, 10); // base 10

    let objectClasses = [];
    let objectCounts = [];
    predictions.forEach(prediction => {
        if (objectClasses.includes(prediction.class)) {
            objectCounts[objectClasses.indexOf(prediction.class)] += 1;
        } 
        else {
            objectClasses[objectClasses.length] = prediction.class;
            objectCounts[objectCounts.length] = 1;
        }
    });
    canvas.height += textHeight*objectClasses.length;

    const ctx = canvas.getContext("2d");
    ctx.font = font;
    ctx.textBaseline = "top";
    ctx.drawImage(video, 0, 0, video.clientWidth, video.clientHeight);
    
    predictions.forEach(prediction => {
        const x = prediction.bbox[0];
        const y = prediction.bbox[1];
        const width = prediction.bbox[2];
        const height = prediction.bbox[3];

        // Bounding box
        ctx.strokeStyle = "#00FFFF";
        ctx.lineWidth = 2;
        ctx.strokeRect(x, y, width, height);

        // Label background
        ctx.fillStyle = "#00FFFF";
        const textWidth = ctx.measureText(prediction.class).width;
        ctx.fillRect(x, y, textWidth + 4, textHeight + 4);

        ctx.fillStyle = "#FFFFFF";
        ctx.fillRect(0, video.clientHeight, canvas.width, textHeight * objectClasses.length);
        ctx.fillStyle = "#000000";
        ctx.fillText(prediction.class, x, y);
    });

    for (let i = 0; i < objectClasses.length; i++) {
        let text = "Object: " + objectClasses[i] + ", Count: " + objectCounts[i]
        ctx.fillText(text, 0, canvas.height - textHeight*(1 + i));
    }

    lastDetections = predictions;
    objectDetectionLabel.hidden = false;
    canvas.hidden = false;
});

/**
 * Save object detecting canvas and evidence notes to pdf
 */
async function saveReportToServer(doc) {
  const blob = doc.output('blob');
  const stamp = new Date().toISOString().replace(/[:.]/g, '-');
  const filename = `${docName.value}-${stamp}.pdf`;

  const form = new FormData();
  form.append('csrfToken', window.APP_CONFIG.csrfToken);
  form.append('documentName', `Evidence Report ${new Date().toLocaleString()}`);
  form.append('document', new File([blob], filename, { type: 'application/pdf' }));

  const response = await fetch(window.APP_CONFIG.uploadUrl, {
    method: 'POST',
    body: form,
    credentials: 'same-origin'
  });

  if (!response.ok) {
    throw new Error(`Upload failed (HTTP ${response.status})`);
  }
  return response;
}

saveButton.addEventListener('click', async () => {
    const doc = new jsPDF({ unit: 'pt', format: 'letter' });
    const pageWidth = doc.internal.pageSize.getWidth();
    const pageHeight = doc.internal.pageSize.getHeight();
    const margin = 40;
    const contentWidth = pageWidth - margin * 2;
    let y = margin;

    // Title
    doc.setFontSize(18);
    doc.text('Evidence Report', margin, y);
    y += 20;
    doc.setFontSize(10);
    doc.text(new Date().toLocaleString(), margin, y);
    y += 25;

    // Save canvas image
    if (canvas && canvas.width > 0 && canvas.height > 0) {
        const imgData = canvas.toDataURL('image/png');
        const imgHeight = (canvas.height / canvas.width) * contentWidth;
        doc.setFontSize(12);
        doc.text('Detection Snapshot', margin, y);
        y += 10;
        doc.addImage(imgData, 'PNG', margin, y, contentWidth, imgHeight);
        y += imgHeight + 25;
    }

    // Detections table
    const rows = lastDetections.map((d, i) => [
        i + 1,
        d.class,
        (d.score * 100).toFixed(1) + '%',
        d.bbox.map(n => Math.round(n)).join(', ')
    ]);

    autoTable(doc, {
        startY: y,
        head: [['#', 'Object', 'Confidence', 'Box (x, y, w, h)']],
        body: rows.length ? rows : [['', 'No objects detected', '', '']],
        margin: { left: margin, right: margin },
        headStyles: { fillColor: [255, 157, 29] }
    });
    y = doc.lastAutoTable.finalY + 25;

    // Notes (wrapped, with page breaks)
    const notes = evidenceNotesInput.value || '(no notes)';
    doc.setFontSize(12);
    if (y > pageHeight - margin - 40) { doc.addPage(); y = margin; }
    doc.text('Notes', margin, y);
    y += 16;
    doc.setFontSize(10);
    const lines = doc.splitTextToSize(notes, contentWidth);
    const lineHeight = 14;
    lines.forEach(line => {
        if (y > pageHeight - margin) { doc.addPage(); y = margin; }
        doc.text(line, margin, y);
        y += lineHeight;
    });

    doc.save(`${docName.value}.pdf`);
    try {
        await saveReportToServer(doc);
        alert('Report saved to Audit Evidence.');
    } catch (err) {
        console.error(err);
        alert('Could not save the report. Please try again.');
    }
});