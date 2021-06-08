modal_about <- function() {
  showModal(
    modalDialog(
      box(
        width = 12,
        # h5("Background"),
        # p("This app was designed by City of Seaside personnel to engage with ESCA property data. To use the app, toggle on and off each desired layer on the upper right hand corner."),
        # tags$hr(),
        h3("Disclaimer"),
        p("The data included in this app are all made freely available by the Seaside ESCA Long-Term Obligations Management Program (ESCA). These data are provided 'AS IS.' ESCA makes no warranties, express or implied, including without limitation, any implied warranties of merchantability and/or fitness for a particular purpose, regarding the accuracy, completeness, value, quality, validity, merchantability, suitability, and/or condition, of the data. Users are hereby notified that current public primary information sources should be consulted for verification of the data and information contained herein."),
        tags$hr(),
        tags$h3("Metadata"),
        tags$p("The data for this application were procured through the",
               tags$a(href = "https://www.fortordsafety.com/",
                      "fortordsafety.com"),
               "site, which is the primary portal for  Military Munitions Recognition and Safety Training, sponsored by the Seaside ESCA Long-Term Obligations Management Program."),
        tags$p("As a condition for excavation permits, all personnel working on the site must complete the training prior to begining ground disturbance. The training teaches workers how to:"),
        tags$ul(
          tags$li("Identify potential munitions;"),
          tags$li("What to do in the event a munitions is discovered;"),
          tags$li("Procedures for reporting suspect munitions,")
        ),
        tags$hr(),
        p("All code used for this app is available on", tags$a(id = "link", href = "https://github.com/cjcallag/fosafety", "Github."), "For questions please email Chris Callaghan at ccallaghan@ci.seaside.ca.us.")
      )
    )
  )
}

