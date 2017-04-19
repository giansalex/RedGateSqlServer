SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Doc_CompraLtr]
AS
SELECT     c.RucE, c.Ejer, c.RegCtb, c.Cd_Prv, CASE WHEN isnull(c.DR_CdTD, '') = '' THEN c.Cd_TD ELSE c.DR_CdTD END AS DR_CdTD, CASE WHEN isnull(c.DR_NSre, '') 
                      = '' THEN c.NroSre ELSE c.DR_NSre END AS DR_NSre, CASE WHEN isnull(c.DR_NDoc, '') = '' THEN c.NroDoc ELSE c.DR_NDoc END AS DR_NDoc, c.Cd_Com, 
                      '' AS Cd_Vou, '' AS Cd_Ltr, c.Cd_TD, t.NCorto AS NomTD, c.NroSre, c.NroDoc, o.Cd_Mda, m.Simbolo AS NomMda, c.CamMda, 
                      0 - CASE WHEN o.Cd_Mda = '01' THEN o.Total ELSE CONVERT(decimal(13, 2), o.Total * isnull(c.CamMda, 0)) END AS SaldoS, 
                      0 - CASE WHEN o.Cd_Mda = '02' THEN o.Total ELSE CASE WHEN isnull(c.CamMda, 0) = 0 THEN 0.00 ELSE CONVERT(decimal(13, 2), o.Total / c.CamMda) 
                      END END AS SaldoD
FROM         dbo.Compra AS c LEFT OUTER JOIN
                      dbo.Moneda AS m ON m.Cd_Mda = c.Cd_Mda LEFT OUTER JOIN
                      dbo.TipDoc AS t ON t.Cd_TD = c.Cd_TD INNER JOIN
                      dbo.CanjePagoDet AS o ON o.RucE = c.RucE AND o.Cd_Com = c.Cd_Com AND o.Cd_TD = c.Cd_TD AND o.NroSre = c.NroSre AND o.NroDoc = c.NroDoc INNER JOIN
                      dbo.CanjePago AS j ON j.RucE = o.RucE AND j.Cd_Cnj = o.Cd_Cnj AND ISNULL(j.IB_Anulado, 0) = 0
WHERE     (ISNULL(c.IB_Anulado, 0) = 0) AND (ISNULL(c.IB_Anulado, 0) = 0)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 125
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o"
            Begin Extent = 
               Top = 126
               Left = 236
               Bottom = 245
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "j"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'Doc_CompraLtr', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Doc_CompraLtr', NULL, NULL
GO
