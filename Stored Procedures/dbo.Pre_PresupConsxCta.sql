SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_PresupConsxCta]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@ckcc bit,
@Cd_cc nvarchar(200),
@cksc bit,
@Cd_sc nvarchar(200),
@ckss bit,
@Cd_ss nvarchar(200),
@Moneda nvarchar(2),
@msj varchar(100) output

as

declare @prd nvarchar(4000)
set @prd = 'Case('''+@Moneda+''') when ''01'' then isnull(Ene,0) else isnull(Ene_ME,0) end as ''1'',
	Case('''+@Moneda+''') when ''01'' then isnull(Feb,0) else isnull(Feb_ME,0) end as ''2'',
	Case('''+@Moneda+''') when ''01'' then isnull(Mar,0) else isnull(Mar_ME,0) end as ''3'',
	Case('''+@Moneda+''') when ''01'' then isnull(Abr,0) else isnull(Abr_ME,0) end as ''4'',
	Case('''+@Moneda+''') when ''01'' then isnull(May,0) else isnull(May_ME,0) end as ''5'',
	Case('''+@Moneda+''') when ''01'' then isnull(Jun,0) else isnull(Jun_ME,0) end as ''6'',
	Case('''+@Moneda+''') when ''01'' then isnull(Jul,0) else isnull(Jul_ME,0) end as ''7'',
	Case('''+@Moneda+''') when ''01'' then isnull(Ago,0) else isnull(Ago_ME,0) end as ''8'',
	Case('''+@Moneda+''') when ''01'' then isnull(Sep,0) else isnull(Sep_ME,0) end as ''9'',
	Case('''+@Moneda+''') when ''01'' then isnull(Oct,0) else isnull(Oct_ME,0) end as ''10'',
	Case('''+@Moneda+''') when ''01'' then isnull(Nov,0) else isnull(Nov_ME,0) end as ''11'',
	Case('''+@Moneda+''') when ''01'' then isnull(Dic,0) else isnull(Dic_ME,0) end as ''12'''

declare @sql nvarchar(4000)
declare @w nvarchar(4000)
print @prd

if(@ckcc= 1)
begin
	if(@cksc=1)
	begin
		if(@ckss =1)
			exec ('select CC, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12] from (select isnull(''SS_''+SS.NCorto, isnull(''SC_''+SC.Ncorto, ''CC_''+CC.Ncorto) )  as ''CC'', SS.Cd_SS  as Cd, 
		'+@prd+'
		from Presupuesto as P 
		 right join CCostos as CC on P.RucE = CC.RucE and P.Cd_CC = CC.Cd_CC
		right join CCSub as SC on P.RucE = SC.RucE and P.Cd_CC = SC.Cd_CC  and P.Cd_SC = SC.Cd_SC
		right join CCSubSub as SS on P.RucE = SS.RucE and P.Cd_CC = SS.Cd_CC  and P.Cd_SC = SS.Cd_SC  and P.Cd_SS = SS.Cd_SS
		where SS.RucE='''+@RucE+''' and isnull(P.Ejer,'''+@Ejer+''' )='''+@Ejer+''' and SS.Cd_CC in ('+@Cd_cc+') and SS.Cd_SC in ('+@Cd_sc+') and SS.Cd_SS in ('+@Cd_ss+')
		UNION ALL
		select ''TOTAL'' as CC,  ''z'' as Cd, 
		'+@prd+'	
		from Presupuesto where RucE  = '''+@RucE+''' and  Ejer='''+@Ejer+''' and Cd_CC = '+@Cd_CC+' and Cd_SC  = '+@Cd_SC+' and Cd_SS is null) as CC order by Cd')
		else
			exec ('select CC, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12] from (select isnull(''SS_''+SS.NCorto, isnull(''SC_''+SC.Ncorto, ''CC_''+CC.Ncorto) )  as ''CC'', SC.Cd_SC  as Cd, 
		'+@prd+'
		from Presupuesto as P 
		right join CCostos as CC on P.RucE = CC.RucE and P.Cd_CC = CC.Cd_CC
		right join CCSub as SC on P.RucE = SC.RucE and P.Cd_CC = SC.Cd_CC  and P.Cd_SC = SC.Cd_SC
		left join CCSubSub as SS on P.RucE = SS.RucE and P.Cd_CC = SS.Cd_CC  and P.Cd_SC = SS.Cd_SC  and P.Cd_SS = SS.Cd_SS
		where SC.RucE='''+@RucE+''' and  isnull(P.Ejer,'''+@Ejer+''' )='''+@Ejer+''' and SC.Cd_CC in ('+@Cd_cc+') and SC.Cd_SC in ('+@Cd_sc+') and P.Cd_SS is null
		UNION ALL
		select ''TOTAL'' as CC,  ''z'' as Cd, 
		'+@prd+'	
		from Presupuesto where RucE  = '''+@RucE+''' and  Ejer='''+@Ejer+''' and Cd_CC = '+@Cd_CC+' and Cd_SC is null and Cd_SS is null) as CC order by Cd')
	end
	else
		exec ('select CC, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12] from (select isnull(''SS_''+SS.NCorto, isnull(''SC_''+SC.Ncorto, ''CC_''+CC.Ncorto) )  as ''CC'', CC.Cd_CC  as Cd, 
		'+@prd+'
		from Presupuesto as P 
		 right join CCostos as CC on P.RucE = CC.RucE and P.Cd_CC = CC.Cd_CC
		left join CCSub as SC on P.RucE = SC.RucE and P.Cd_CC = SC.Cd_CC  and P.Cd_SC = SC.Cd_SC
		left join CCSubSub as SS on P.RucE = SS.RucE and P.Cd_CC = SS.Cd_CC  and P.Cd_SC = SS.Cd_SC  and P.Cd_SS = SS.Cd_SS
		where CC.RucE='''+@RucE+''' and isnull(P.Ejer,'''+@Ejer+''' )='''+@Ejer+''' and CC.Cd_CC in ('+@Cd_cc+') and  P.Cd_SC is null
		UNION ALL
		select ''TOTAL'' as CC,  ''z'' as Cd, 
		'+@prd+'
		from Presupuesto where RucE  = '''+@RucE+''' and  Ejer='''+@Ejer+''' and Cd_CC is  null and Cd_SC is null and Cd_SS is null) as CC order by Cd')
end
else
	exec ('select CC, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12] from (select isnull(''SS_''+SS.NCorto, isnull(''SC_''+SC.Ncorto, ''CC_''+CC.Ncorto) )  as ''CC'', P.Cd_CC  as Cd, 
		'+@prd+'
		from Presupuesto as P 
		left join CCostos as CC on P.RucE = CC.RucE and P.Cd_CC = CC.Cd_CC
		left join CCSub as SC on P.RucE = SC.RucE and P.Cd_CC = SC.Cd_CC  and P.Cd_SC = SC.Cd_SC
		left join CCSubSub as SS on P.RucE = SS.RucE and P.Cd_CC = SS.Cd_CC  and P.Cd_SC = SS.Cd_SC  and P.Cd_SS = SS.Cd_SS
		where CC.RucE='''+@RucE+''' and P.Ejer='''+@Ejer+'''and P.Cd_SC is null  and  isnull(''SS_''+SS.NCorto, isnull(''SC_''+SC.Ncorto, ''CC_''+CC.Ncorto) ) is not null --order by P.Cd_CC
		UNION ALL
		select ''TOTAL'' as CC,  ''z'' as Cd, 
		'+@prd+'
		from Presupuesto where RucE  = '''+@RucE+''' and  Ejer='''+@Ejer+''' and Cd_CC is null and Cd_SC is null and Cd_SS is null) as CC order by Cd')
		
-- Leyenda --
-- PP : 2010-09-14 13:38:38.440	: <Creacion del procedimiento almacenado>

--MP: 04-11-2010: <Modificacion del procedimiento almacenado> 
--exec dbo.Pre_PresupConsxCta '11111111111', '2010', '14.1.0.06', 0, '', 0, '', 0, '', '01', null 
GO
