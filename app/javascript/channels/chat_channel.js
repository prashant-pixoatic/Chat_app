import consumer from "./consumer";

document.addEventListener('DOMContentLoaded', function () {
  const chatRoom = document.getElementById('chat-room');
  if (chatRoom) {
    const receiverId = chatRoom.dataset.receiverId;
    const userId = chatRoom.dataset.userId;
    const groupId = chatRoom.dataset.groupId;
    let cableSubscription;

    if (groupId) {
      cableSubscription = consumer.subscriptions.create(
        { channel: "ChatChannel", group_id: groupId, user_id: userId },
        {
          connected() {
            console.log(`Connected to group chat with ${groupId}`);
          },

          disconnected() {
            console.log("Disconnected from chat room");
          },

          received(data) {
            if (data.message.audio_url) {
              const audio = new Audio(data.message.audio_url);
              audio.play();
            } else {
              const messageList = document.getElementById('messages');
              if (messageList) {
                const messageItem = document.createElement('li');
                messageItem.innerHTML = data.message;
                messageList.appendChild(messageItem);
              }
            }
          },

          speak(data) {
            this.perform('speak', data);
          }
        }
      );
    } else {
      cableSubscription = consumer.subscriptions.create(
        { channel: "ChatChannel", receiver_id: receiverId,  user_id: userId},
        {
          connected() {
            console.log(`Connected to private chat room with user ${receiverId}`);
          },

          disconnected() {
            console.log("Disconnected from chat room");
          },

          received(data) {
            if (data.message.audio_url) {
              const audio = new Audio(data.message.audio_url);
              audio.play();
            } else {
              const messageList = document.getElementById('messages');
              if (messageList) {
                const messageItem = document.createElement('li');
                messageItem.innerHTML = data.message;
                messageList.appendChild(messageItem);
              }
            }
          },
          
          speak(data) {
            this.perform('speak', data);
          }
        }
      );
    }

    const sendMessageButton = document.getElementById('send-message-btn');
    const messageInput = document.getElementById('message-input');

    if (sendMessageButton && messageInput) {
      sendMessageButton.addEventListener('click', function () {
        const message = messageInput.value.trim();


        if (message) {
          const dataToSend = { 
            message: message, 
            user_id: userId 
          };

          if (groupId) {
            dataToSend.group_id = groupId;
          } 
          else if (receiverId) {
            dataToSend.receiver_id = receiverId;
          }
          cableSubscription.speak(dataToSend);
          messageInput.value = '';
        } else {
          console.log("Message is empty, not sending.");
        }
      });
    }

    let mediaRecorder;
    let audioChunks = [];
    const audioPreview = document.getElementById('audio-preview');
    const startRecordingButton = document.getElementById('start-recording');
    const stopRecordingButton = document.getElementById('stop-recording');

    startRecordingButton.addEventListener('click', function () {
      startRecordingButton.disabled = true;
      stopRecordingButton.disabled = false;

      navigator.mediaDevices.getUserMedia({ audio: true })
        .then(stream => {
          mediaRecorder = new MediaRecorder(stream);
          mediaRecorder.start();

          mediaRecorder.ondataavailable = event => {
            audioChunks.push(event.data);
          };

          mediaRecorder.onstop = () => {
            const audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
            const audioUrl = URL.createObjectURL(audioBlob);
            audioPreview.src = audioUrl;
            sendAudioToBackend(audioBlob);
          };
        });
    });

    stopRecordingButton.addEventListener('click', function () {
      mediaRecorder.stop();
      startRecordingButton.disabled = false;
      stopRecordingButton.disabled = true;
    });

    function sendAudioToBackend(audioBlob) {
      const reader = new FileReader();
    
      reader.onloadend = function () {
        const base64Audio = reader.result.split(',')[1];
    
        const data = {
          user_id: userId,
          audio_file: base64Audio,
        };
    
        if (groupId) {
          data.group_id = groupId;
        } else if (receiverId) {
          data.receiver_id = receiverId;
        }
        
        console.log(data)
        const message = {type: "audio", data: data, action: "speak"}
    
        cableSubscription.speak(message);
      };
    
      reader.readAsDataURL(audioBlob);
    }
  }
});
