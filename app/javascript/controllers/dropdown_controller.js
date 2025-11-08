import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "icon"]

  connect(){
    this.timeout = null
    this.open = false
    if(this.element.classList.contains("active")){
      this.open = !this.open
      this.menuTarget.classList.remove("hidden") 
    }
  }

  toggle(){
    this.open = !this.open
    this.menuTarget.classList.toggle("hidden", !this.open) 
    if(this.hasIconTarget){
      this.iconTarget.classList.toggle("rotate-180", this.open);
    }
  }

  show(){
    clearTimeout(this.timeout)
    this.menuTarget.classList.remove("invisible", "opacity-0")
    this.menuTarget.classList.add("visible", "opacity-100")
  }

  hide(){
    this.timeout = setTimeout(()=>{
    this.menuTarget.classList.remove("visible", "opacity-100")
    this.menuTarget.classList.add("invisible", "opacity-0")
    }, 1000)
  }

  close(event){
    if(!this.element.contains(event.target)){
      this.open = false
      this.menuTarget.classList.add("hidden")
      if (this.hasIconTarget) {
        this.iconTarget.classList.remove("rotate-180")
      }
    }
  }
}