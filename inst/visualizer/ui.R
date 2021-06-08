# Disabled pieces --------------------------------------------------------------
header <- dashboardHeader(disable = TRUE)
sidebar <- dashboardSidebar(disable = TRUE)
# Enabled structure ------------------------------------------------------------
body <- dashboardBody(
    includeCSS("www/my_css.css"),
    tags$head(HTML("<link rel='icon' href='ESCA-logo.png' type='image/png'/>")),
        fluidRow(
            column(width = 3,
                   box(width = 12, height = "500px",
                       titlePanel(title = div(
                           fluidRow(
                               column(width = 4,
                                      img(src = "ESCA-logo.png")),
                               column(width = 8,
                                      "Safety Training Visualizer")
                               )),
                           windowTitle = "ESCA Safety Training Visualizer"),
                       tags$br(),
                       tags$p("This dashboard presents real time data from the",
                              tags$a(href = "https://www.fortordsafety.com/",
                                     "fortordsafety.com.")),
                       tags$table(
                           class = "my-table",
                           tags$tr(
                               tags$th("Instructions")
                               ),
                           tags$tr(
                               tags$td("Change the 'Bin choice' to modify how the data is grouped. Each bin represents the grouping of certificates at a given period.")
                               )
                           ),
                       selectInput(inputId = "bin_input",
                                   label = "Bin choice:",
                                   choices = c("Daily bins" = "day",
                                               "Weekly bins" = "week",
                                               "Monthly bins" = "month",
                                               "Yearly bins" = "year")),
                       # TODO Determine whether or not to add grouping.
                       # checkboxInput(inputId = "groups_input",
                       #               label = "Groups?",
                       #               value = FALSE),
                       tags$hr(),
                       tags$div(
                           id = "wrapper",
                           actionButton(inputId = "load_about",
                                        label = "About",
                                        icon = icon("info"),
                                        width = "100px",
                                        class = "my_button")
                           )
                       )
                   ),
            column(width = 9,
                   box(width = 12, height = "500px",
                       shinycssloaders::withSpinner(
                           infoBoxOutput("individuals", width = 6),
                           type = 7),
                       shinycssloaders::withSpinner(
                           infoBoxOutput("groups", width = 6),
                           type = 7),
                       fluidRow(
                           column(width = 12,
                                  shinycssloaders::withSpinner(
                                      plotly::plotlyOutput("line_chart",
                                                           height = "350px"),
                                      type = 7))
                       )
                   ))
        ),
        fluidRow(
            box(width = 12,
                shinycssloaders::withSpinner(
                    DT::dataTableOutput("data_table"), type = 7))
        )
    )
# Piece it all together --------------------------------------------------------
dashboardPage(header = header, sidebar = sidebar, body = body)
