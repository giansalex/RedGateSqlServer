SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Srv_TareaProgramada_Cons]
@RucE nvarchar(11),
@TareaID char(10)
As 
Select		
				 Tp.RucE
				,Tp.TareaProgramadaID
				,Tp.Correo
				,Tp.FechaInicio
				,Tp.FechaFin
				,Tp.SoloLunes
				,Tp.SoloMartes
				,Tp.SoloMiercoles
				,Tp.SoloJueves
				,Tp.SoloViernes
				,Tp.SoloSabados
				,Tp.SoloDomingos
				,Tp.EsRecurrente
				,Tp.Hora1
				,Tp.Hora2
				,Tp.Hora3
				,Tp.Estado
				,Tp.Asunto
				,Tp.AltaPrioridad
				,Tpd.ReporteID
				,Rpt.NombreReporte
From 
				TareaProgramada as Tp 
Inner Join
				TareaProgramadaParametro as Tpd
On
				Tp.RucE = Tpd.RucE 
				And
				Tp.TareaProgramadaID = Tpd.TareaProgramadaID
Inner Join
				Reportes as Rpt
On
				Tpd.RucE = Rpt.RucE
				And
				Tpd.ReporteID = Rpt.ReporteID
where 
				Tp.RucE = @RucE And (Tp.TareaProgramadaID = @TareaID OR @TareaID IS NULL)
Group By		Tp.RucE
				,Tp.TareaProgramadaID
				,Tp.Correo
				,Tp.FechaInicio
				,Tp.FechaFin
				,Tp.SoloLunes
				,Tp.SoloMartes
				,Tp.SoloMiercoles
				,Tp.SoloJueves
				,Tp.SoloViernes
				,Tp.SoloSabados
				,Tp.SoloDomingos
				,Tp.EsRecurrente
				,Tp.Hora1
				,Tp.Hora2
				,Tp.Hora3
				,Tp.Estado
				,Tp.Asunto
				,Tp.AltaPrioridad
				,Tpd.ReporteID
				,Rpt.NombreReporte				
GO
