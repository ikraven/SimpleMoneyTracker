 Chart(viewModel.categoryAmmount) { data in
                        BarMark(
                            x: .value("Categoría", data.Category.name),
                            y: .value("Gasto", data.TotalAmmount),
                            width: 20
                        )
                        .foregroundStyle(data.Category.getColor())
                        .clipShape(
                            RoundedCorner(radius: 5, corners: [.topLeft, .topRight])
                        )
                    }
                    .frame(height: 200)
                    .aspectRatio(1, contentMode: .fit)
                    .chartPlotStyle { plotArea in
                        plotArea.frame(height: 200)
                    }