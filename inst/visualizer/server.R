shinyServer(function(input, output) {
    # Load modal ---------------------------------------------------------------
    observeEvent(input$load_about, {
        modal_about()
    })
    # Reactive data fetcher ----------------------------------------------------
    get_data <- reactive({
        out <- fosafety::pull_data() |>
            fosafety::process_data()
        out
    })
    # infoBox ------------------------------------------------------------------
    output$individuals <- renderInfoBox({
        res <- length(unique(get_data()[["idval"]]))
        infoBox(title = "Individuals Trained",
                subtitle = "Number of individual certificates",
                value = res, icon = icon("user-circle"), fill = TRUE)
    })
    output$groups <- renderInfoBox({
        res <- table(get_data()[["member"]] == "contact")[["TRUE"]]
        infoBox(title = "Groups", subtitle = "Number of trained cohorts",
                value = res, icon = icon("users"), fill = TRUE)
    })
    # plot_ly ------------------------------------------------------------------
    output$line_chart <- plotly::renderPlotly({
        res <- get_data() |>
            fosafety::summarize_data(.by = input$bin_input,
                                     .groups = FALSE)
        res <- res[order(floor_date)]
        out <- plotly::plot_ly() |>
            plotly::add_trace(mode = "lines",
                              type = "scatter",
                              y = res[[2]],
                              x = res[[1]]) |>
            layout(legend = list(x = 0.1, y = 0.9))
        out
    })
    # datatable ----------------------------------------------------------------
    output$data_table <- DT::renderDataTable({
        res <- get_data()
        res <- res[, .(fname, last, email, employer, group, member, idval,
                       date)][, member := fcase(member == "contact", "Group Contact",
                                                member == "individual", "Individual",
                                                member == "member", "Group Member")
                              ][, c("fname", "last", "employer", "group") :=
                                    .(stringi::stri_trans_totitle(fname),
                                      stringi::stri_trans_totitle(last),
                                      stringi::stri_trans_totitle(employer),
                                      stringi::stri_trans_totitle(group))
                                ][order(-date)]
        setnames(res, old = c("fname", "last", "email", "employer", "group",
                              "member", "idval", "date"),
                 new = c("First Name", "Last Name", "Email", "Employer",
                         "Group", "Type", "Certificate", "Date"))
        res |>
            DT::datatable(rownames = FALSE, escape = TRUE,
                          extensions = c("Buttons"),
                          options = list(pageLength = 5,
                                         autoWidth = TRUE,
                                         dom = "Bfrtip",
                                         buttons = c("copy", "csv")
                                         ))
        })
})
