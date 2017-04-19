SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Leyenda --
 DI : 19/12/2012 <Creacion de la Vista>	*/
CREATE VIEW [dbo].[Doc_VentaCbr]
AS
SELECT     v.RucE, v.Eje AS Ejer, v.RegCtb, v.Cd_Clt, CASE WHEN isnull(v.DR_CdTD, '') = '' THEN v.Cd_TD ELSE v.DR_CdTD END AS DR_CdTD, CASE WHEN isnull(v.DR_NSre, 
                      '') = '' THEN v.NroSre ELSE v.DR_NSre END AS DR_NSre, CASE WHEN isnull(v.DR_NDoc, '') = '' THEN v.NroDoc ELSE v.DR_NDoc END AS DR_NDoc, v.Cd_Vta, 
                      '' AS Cd_Vou, '' AS Cd_Ltr, v.Cd_TD, t.NCorto AS NomTD, v.NroSre, v.NroDoc, v.Cd_Mda, m.Simbolo AS NomMda, v.CamMda, ISNULL(SUM(o.MtoD - o.MtoH), 0.00) 
                      AS SaldoS, ISNULL(SUM(o.MtoD_ME - o.MtoH_ME), 0.00) AS SaldoD
FROM         dbo.Venta AS v LEFT OUTER JOIN
                      dbo.Moneda AS m ON m.Cd_Mda = v.Cd_Mda LEFT OUTER JOIN
                      dbo.TipDoc AS t ON t.Cd_TD = v.Cd_TD INNER JOIN
                      dbo.Voucher AS o ON o.RucE = v.RucE AND o.Cd_Clt = v.Cd_Clt AND o.Cd_TD = v.Cd_TD AND o.NroSre = v.NroSre AND o.NroDoc = v.NroDoc
WHERE     (ISNULL(v.IB_Anulado, 0) = 0) AND (SUBSTRING(o.RegCtb, 1, 1) <> 'L') AND (CASE WHEN o.Cd_Fte = 'LD' THEN 0 ELSE ISNULL(o.IB_EsProv, 0) END = 0)
GROUP BY v.RucE, v.Eje, v.RegCtb, v.Cd_Clt, CASE WHEN isnull(v.DR_CdTD, '') = '' THEN v.Cd_TD ELSE v.DR_CdTD END, CASE WHEN isnull(v.DR_NSre, '') 
                      = '' THEN v.NroSre ELSE v.DR_NSre END, CASE WHEN isnull(v.DR_NDoc, '') = '' THEN v.NroDoc ELSE v.DR_NDoc END, v.Cd_Vta, v.Cd_TD, t.NCorto, v.NroSre, 
                      v.NroDoc, v.Cd_Mda, m.Simbolo, v.CamMda
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
         Begin Table = "v"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 6
               Left = 252
               Bottom = 125
               Right = 428
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "o"
            Begin Extent = 
               Top = 126
               Left = 252
               Bottom = 245
               Right = 428
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
      Begin ColumnWidths = 12
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
', 'SCHEMA', N'dbo', 'VIEW', N'Doc_VentaCbr', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Doc_VentaCbr', NULL, NULL
GO
