document.querySelectorAll("[data-confirm], [data-confirm-form]").forEach((element) => {
  const eventName = element.tagName === "FORM" ? "submit" : "click";
  element.addEventListener(eventName, (event) => {
    const message = element.dataset.confirm || element.dataset.confirmForm;
    if (message && !window.confirm(message)) event.preventDefault();
  });
});

document.querySelectorAll("[data-modal]").forEach((button) => {
  button.addEventListener("click", () => {
    const modal = document.getElementById(button.dataset.modal);
    if (!modal) return;

    if (modal.id === "doorModal") {
      document.getElementById("doorAction").value = "add_door";
      document.getElementById("doorTitle").textContent = "Add Door";
      document.getElementById("doorId").readOnly = false;
      document.getElementById("doorName").value = "";
      document.getElementById("doorId").value = "";
      document.getElementById("deleteDoorBtn")?.remove();
      document.getElementById("apiKeyField").hidden = true;
    } else if (modal.id === "userModal") {
      const form = modal.querySelector('form');
      form.reset();
      document.getElementById("userAction").value = "add_user";
      document.getElementById("userTitle").textContent = "Add User";
      document.getElementById("userId").value = "";
      document.getElementById("userType").value = "rfid";
      document.getElementById("deleteUserBtn")?.remove();
    }
    modal?.classList.add("open");
    // Kirim event 'show' untuk ditangkap oleh skrip inline di index.php
    const showEvent = new CustomEvent('show', { bubbles: true, cancelable: true });
    modal?.dispatchEvent(showEvent);
  });
});

document.querySelectorAll("[data-close]").forEach((button) => button.addEventListener("click", () => button.closest(".modal")?.classList.remove("open")));
document.querySelectorAll(".modal").forEach((modal) => modal.addEventListener("click", (event) => { if (event.target === modal) modal.classList.remove("open"); }));

document.querySelectorAll("[data-edit-door]").forEach((button) => {
  button.addEventListener("click", () => {
    const modal = document.getElementById("doorModal");
    document.getElementById("doorAction").value = "edit_door";
    document.getElementById("doorTitle").textContent = "Edit Door";
    document.getElementById("doorName").value = button.dataset.name || "";
    document.getElementById("doorId").value = button.dataset.id || "";
    document.getElementById("doorId").readOnly = true;

    if (!document.getElementById("deleteDoorBtn")) {
      const deleteBtn = document.createElement("button");
      deleteBtn.type = "submit";
      deleteBtn.name = "action";
      deleteBtn.value = "delete_door";
      deleteBtn.className = "btn danger";
      deleteBtn.id = "deleteDoorBtn";
      deleteBtn.form = "deleteDoorForm";
      deleteBtn.dataset.confirmForm = "Hapus perangkat ini? Semua data terkait akan hilang.";
      deleteBtn.textContent = "Delete";
      modal.querySelector(".modal-actions").prepend(deleteBtn);
    }

    document.getElementById("apiKeyField").hidden = false;
    document.getElementById("doorApiKey").value = button.dataset.key || "";
    document.getElementById("deleteDoorId").value = button.dataset.id || "";
    modal.classList.add("open");
  });
});

document.querySelectorAll("[data-edit-user]").forEach((button) => {
  button.addEventListener("click", () => {
    const modal = document.getElementById("userModal");
    if (!modal) return;

    const hasUid = button.dataset.uid && button.dataset.uid !== '-';
    const hasUsername = button.dataset.username && button.dataset.username !== '-';
    let userType = 'rfid';
    if (hasUid && hasUsername) userType = 'both';
    else if (hasUsername) userType = 'web';

    modal.querySelector("#userAction").value = "edit_user";
    modal.querySelector("#userTitle").textContent = "Edit User";
    modal.querySelector("#userId").value = button.dataset.id || "";
    modal.querySelector("#userName").value = button.dataset.name || "";
    modal.querySelector("#userUid").value = hasUid ? button.dataset.uid : "";
    modal.querySelector("#userUsername").value = hasUsername ? button.dataset.username : "";
    modal.querySelector("#userType").value = userType;

    if (!modal.querySelector("#deleteUserBtn")) {
      const deleteBtn = document.createElement("button");
      deleteBtn.type = "submit";
      deleteBtn.name = "action";
      deleteBtn.value = "delete_user";
      deleteBtn.className = "btn danger";
      deleteBtn.id = "deleteUserBtn";
      deleteBtn.form = "deleteUserForm";
      deleteBtn.dataset.confirmForm = "Hapus pengguna ini?";
      deleteBtn.textContent = "Delete";
      modal.querySelector(".modal-actions").prepend(deleteBtn);
    }

    const deleteUserForm = document.getElementById("deleteUserForm");
    if (deleteUserForm) deleteUserForm.querySelector("#deleteUserId").value = button.dataset.id || "";

    const selected = (button.dataset.doors || "").split(",");
    modal.querySelectorAll('input[name="access_doors[]"]').forEach((input) => input.checked = selected.includes(input.value));
    modal.classList.add("open");
    modal.dispatchEvent(new CustomEvent('show'));
  });
});
async function refreshDeviceStatus() {
  const rows = document.getElementById("deviceRows");
  if (!rows) return;
  try {
    const response = await fetch("../api/devices.php?action=status", { cache: "no-store" });
    const result = await response.json();
    if (!result.success || !Array.isArray(result.data)) return;
    result.data.forEach((device) => {
      const row = rows.querySelector(`[data-device-id="${CSS.escape(device.device_id)}"]`);
      const badge = row?.querySelector("[data-device-status]");
      if (!badge) return;
      const status = device.status === "ONLINE" ? "ONLINE" : "OFFLINE";
      badge.className = `pill ${status.toLowerCase()}`; // Hapus <i></i>
      badge.textContent = status;

      const unlockButton = row?.querySelector("button.unlock");
      if (unlockButton) unlockButton.disabled = status === "OFFLINE";
    });
  } catch (_) {}
}
refreshDeviceStatus();
window.setInterval(refreshDeviceStatus, 5000);

document.addEventListener('DOMContentLoaded', () => {
  const alerts = document.querySelectorAll('.alert');
  if (alerts.length > 0) {
    alerts.forEach(alert => {
      setTimeout(() => {
        alert.style.transition = 'opacity 0.5s ease';
        alert.style.opacity = '0';
        setTimeout(() => alert.remove(), 500); // Remove after fade out
      }, 3000); // 3 seconds
    });
  }
});
