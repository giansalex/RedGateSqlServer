SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_NroDocGenera2]
@RucE nvarchar(11),
@msj varchar(100) output
as
declare @Cd_TD nvarchar(2)
declare Cur_TD cursor for select distinct Cd_TD from Serie s right join Numeracion n on s.RucE = n.RucE and s.Cd_Sr = n.Cd_Sr where s.RucE = @RucE order by Cd_TD
open Cur_TD
	fetch Cur_TD into @Cd_TD
		while(@@fetch_status = 0)
		begin	
			select * from 
			((select T_Sre.Cd_TD,T_Sre.NroSerie, T_Sre.Cd_Sr ,isnull(T_Nro.NroDoc,T_Sre.NroSreI) as NroDoc, T_Sre.NroSreF as NroDocF
			from 
			(select Cd_TD,NroSre,Convert(int, max(NroDoc))+ 1 as NroDoc
			from Venta where RucE = @RucE and NroSre is not null group by Cd_TD, NroSre) as T_Nro 
			right join 
			(select s.Cd_Sr, s.Cd_TD,s.NroSerie,MAX(n.Desde) as NroSreI, MAX(n.Hasta) as NroSreF from Serie s inner join Numeracion n
			on s.RucE = n.RucE and s.Cd_Sr = n.Cd_Sr 
			where s.RucE = @RucE group by s.Cd_Sr,s.Cd_TD,s.NroSerie) as T_Sre
			on T_Nro.Cd_TD = T_Sre.Cd_TD and T_Nro.NroSre = T_Sre.NroSerie)) as T_Result
			where Cd_TD = @Cd_TD order by Cd_Sr
			--group by Cd_TD,NroSerie, Cd_Sr
			fetch Cur_TD into @Cd_TD
		end
close Cur_TD
deallocate Cur_TD
-- Leyenda --
-- JU : 2010-09-13 : <Creacion del procedimiento almacenado>
-- MP : 09/05/2012 : <Modificacion para que no muestre repetidos>
/*
exec user321.Vta_NroDocGenera2 '20520727192', null

declare @RucE nvarchar(11)
declare @Cd_TD nvarchar(2)
set @RucE = '20520727192'

declare Cur_TD cursor for select distinct Cd_TD from Serie s right join Numeracion n on s.RucE = n.RucE and s.Cd_Sr = n.Cd_Sr where s.RucE = @RucE order by Cd_TD
open Cur_TD
	fetch Cur_TD into @Cd_TD
		while(@@fetch_status = 0)
		begin	
			select * from 
			((select T_Sre.Cd_TD,T_Sre.NroSerie, T_Sre.Cd_Sr ,isnull(T_Nro.NroDoc,T_Sre.NroSreI) as NroDoc, T_Sre.NroSreF as NroDocF
			from 
			(select Cd_TD,NroSre,Convert(int, max(NroDoc))+ 1 as NroDoc
			from Venta where RucE = @RucE and NroSre is not null group by Cd_TD, NroSre) as T_Nro 
			right join 
			(select s.Cd_Sr, s.Cd_TD,s.NroSerie,MAX(n.Desde) as NroSreI, MAX(n.Hasta) as NroSreF from Serie s inner join Numeracion n
			on s.RucE = n.RucE and s.Cd_Sr = n.Cd_Sr 
			where s.RucE = @RucE group by s.Cd_Sr,s.Cd_TD,s.NroSerie ) as T_Sre
			on T_Nro.Cd_TD = T_Sre.Cd_TD and T_Nro.NroSre = T_Sre.NroSerie)) as T_Result
			where Cd_TD = @Cd_TD
			--group by Cd_TD,NroSerie, Cd_Sr
			fetch Cur_TD into @Cd_TD
		end
close Cur_TD
deallocate Cur_TD
*/
GO
