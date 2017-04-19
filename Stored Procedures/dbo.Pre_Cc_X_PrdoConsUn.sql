SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_Cc_X_PrdoConsUn]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Moneda nvarchar(2),
@msj varchar(100) output

as

if(isnull(len(@Cd_CC),0)=0) Set @Cd_CC = '*'
if(isnull(len(@Cd_SC),0)=0) Set @Cd_SC = '*'
if(isnull(len(@Cd_SS),0)=0) Set @Cd_SS = '*'

select 
	Case(@Moneda) when '01' then isnull(Ene,0) else isnull(Ene_ME,0) end as '1',
	Case(@Moneda) when '01' then isnull(Feb,0) else isnull(Feb_ME,0) end as '2',
	Case(@Moneda) when '01' then isnull(Mar,0) else isnull(Mar_ME,0) end as '3',
	Case(@Moneda) when '01' then isnull(Abr,0) else isnull(Abr_ME,0) end as '4',
	Case(@Moneda) when '01' then isnull(May,0) else isnull(May_ME,0) end as '5',
	Case(@Moneda) when '01' then isnull(Jun,0) else isnull(Jun_ME,0) end as '6',
	Case(@Moneda) when '01' then isnull(Jul,0) else isnull(Jul_ME,0) end as '7',
	Case(@Moneda) when '01' then isnull(Ago,0) else isnull(Ago_ME,0) end as '8',
	Case(@Moneda) when '01' then isnull(Sep,0) else isnull(Sep_ME,0) end as '9',
	Case(@Moneda) when '01' then isnull(Oct,0) else isnull(Oct_ME,0) end as '10',
	Case(@Moneda) when '01' then isnull(Nov,0) else isnull(Nov_ME,0) end as '11',
	Case(@Moneda) when '01' then isnull(Dic,0) else isnull(Dic_ME,0) end as '12'
from Presupuesto
where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta and isnull(Cd_CC,'*') = @Cd_CC and isnull(Cd_SC,'*') = @Cd_SC and isnull(Cd_SS,'*') = @Cd_SS

--***************** Leyenda *****************--

-- DI : 07/01/2010 <Creacion del procedimiento almacenado>
GO
