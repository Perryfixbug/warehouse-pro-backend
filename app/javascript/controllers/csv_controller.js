import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileName", "submit"]

  fileSelected(event) {
    const file = event.target.files[0]
    if (file) {
      this.fileNameTarget.textContent = `Đã chọn: ${file.name}`
      this.submitTarget.classList.remove("hidden")
    } else {
      this.fileNameTarget.textContent = ""
      this.submitTarget.classList.add("hidden")
    }
  }
}
