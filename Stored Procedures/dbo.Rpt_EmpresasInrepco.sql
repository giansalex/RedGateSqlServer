SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_EmpresasInrepco]
@msj varchar(100) output
as
if not exists(
select top 1 Ruc from Empresa e
inner join AccesoE a on e.Ruc = a.RucE and a.Cd_Prf = '119'
)
begin
set @msj = 'No hay empresas creadas'
end
else
begin
select Ruc from Empresa e
inner join AccesoE a on e.Ruc = a.RucE and a.Cd_Prf = '119'
end
GO
