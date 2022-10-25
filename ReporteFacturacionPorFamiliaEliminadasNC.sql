declare @StartDate  Date,@EndDate  Date;
set @StartDate ='10-18-2022'
set @EndDate ='10-18-2022' /*el 20 mayo 2021* hay que buscar por que no lo genera*/

SELECT 
T0.SysRate
,T11.OnHand
,Familia = Case 
when T11.U_u_familiaa = '100' then 'ADAPTADORES'
when T11.U_u_familiaa = '1000' then 'INSTRUMENTOS DE MEDICION'
when T11.U_u_familiaa = '1100' then 'TERMINALES'
when T11.U_u_familiaa = '1200' then 'VALVULAS'
when T11.U_u_familiaa = '200' then 'ACOPLES'
when T11.U_u_familiaa = '300' then 'PEGAMENTOS'
when T11.U_u_familiaa = '400' then 'BANDAS'
when T11.U_u_familiaa = '500' then 'COMPONENTES PARA BANDAS'
when T11.U_u_familiaa = '600' then 'CORREAS'
when T11.U_u_familiaa = '700' then 'ESPECIALES'
when T11.U_u_familiaa = '800' then 'LOCALES'
when T11.U_u_familiaa = '900' then 'MANGUERAS'
END

,Grupo = case
when T11.ItmsGrpCod = '100' then 'SERVICIOS'
when T11.ItmsGrpCod = '101' then 'ADAPTADORES'
when T11.ItmsGrpCod = '102' then 'ACOPLES'
when T11.ItmsGrpCod = '103' then 'BANDAS'
when T11.ItmsGrpCod = '104' then 'CORREAS'
when T11.ItmsGrpCod = '105' then 'FITTINERIA'
when T11.ItmsGrpCod = '106' then 'GRAPAS'
when T11.ItmsGrpCod = '107' then 'MANGUERAS'
when T11.ItmsGrpCod = '108' then 'MANOMETROS'
when T11.ItmsGrpCod = '109' then 'PEGAMENTOS'
when T11.ItmsGrpCod = '110' then 'TERMINALES'
when T11.ItmsGrpCod = '111' then 'TERMINALES MP'
when T11.ItmsGrpCod = '112' then 'FIRETRACE'
when T11.ItmsGrpCod = '113' then 'MAQUINARIAS'
when T11.ItmsGrpCod = '114' then 'EQ Y ACC. INCENDIO'
when T11.ItmsGrpCod = '117' then 'LOCALES'
when T11.ItmsGrpCod = '118' then 'SI'
when T11.ItmsGrpCod = '119' then 'PISOS'
when T11.ItmsGrpCod = '120' then 'ARTICULOS BIP'
when T11.ItmsGrpCod = '121' then 'INSTRUMENTOS DE MED.'
when T11.ItmsGrpCod = '122' then 'VALVULAS'
when T11.ItmsGrpCod = '124' then 'COMPONENTES P BANDAS'
when T11.ItmsGrpCod = '125' then 'ESPECIALES'
END
--,T1.StockPrice
,T1.WhsCode,
 T0.[CardCode]
 ,Vendedor=case
 when t0.SlpCode = -1 then	'-Ning�n empleado del departamento de ventas-'
 when t0.SlpCode = 1 then 'Cristhian Pe�a'
 when t0.SlpCode = 2 then 'Eliseo Garc�a'
 when t0.SlpCode = 3 then 'Freddy Guti�rrez'
  when t0.SlpCode = 5 then 'Misael Rivera'
 when t0.SlpCode = 6 then 'Ronald Nicaragua'
 when t0.SlpCode = 8 then 'Mart�n Paz'
 when t0.SlpCode = 10 then 'B�hler'
 when t0.SlpCode = 11 then 'Jorge Espinoza'
 when t0.SlpCode =12 then 'Norman Padilla'
 when t0.SlpCode =14 then 'Edwin Perez'
  when t0.SlpCode =15 then 'Yury Chamorro'
  when t0.SlpCode =17 then 'Bip'
  when t0.SlpCode =21 then 'Claudia Cabrera'
  when t0.SlpCode =22 then 'Angel Plazaola'



 end
, T0.[CardName]
, T0.[DocNum]
, T1.[ItemCode]
, T1.[Dscription]
--, T1.[DiscPrcnt]
, T1.[Quantity]

, T1.[Price] ---Muestra Precio que este reflejado en Detalle de Factura puede ser cordobas o dolares--
---, T1.[PriceBefDi]
--,T1.[U_PreciosL]
/*,PrecioCordobas=case
		when T1.Currency = 'USD' THEN 
		T1.LineTotal/T1.Quantity
		
		else
		T1.Price
		end*/

--, (T1.[PriceBefDi] - T1.[Price] ) as 'Descuento' 
--, T1.[Currency] 
,PrecioCordobas=case
		when T1.Currency = 'USD' THEN 
		T1.LineTotal/T1.Quantity
		
		when T1.Price = 0 then T1.[U_PreciosL] 
		else
		T1.Price
		end
,CostoLista_USD=CASE WHEN T1.GrossBuyPr>=0 THEN 
   (Select T.[Price] from ITM1 T where T.ItemCode=T1.Itemcode and T.PriceList=11)
  END 
 ,T1.[LineTotal]----Siempre muestra total en Cordobas---
--,(SELECT T6.Total FROM ITR1 T5 INNER JOIN OITR T6 ON T5.ReconNum=T6.ReconNum 
--WHERE T5.SrcObjTyp =13 AND T5.SrcObjAbs =T0.DocEntry AND T6.InitObjTyp =14 AND T6.ReconDate >=T0.DocDate) NC
--,(SELECT  from INV1 T20  INNER JOIN OITM T11 ON T20.[ItemCode] = T11.[ItemCode] and t20.WhsCode = '01') OnStock
 ,T0.[DocDate] FROM OINV T0  inner JOIN INV1 T1
 ON T0.[DocEntry] = T1.[DocEntry] INNER JOIN OITM T11 
 ON T1.[ItemCode] = T11.[ItemCode] INNER JOIN OSLP T22 
ON T0.[SlpCode] = T22.[SlpCode]
 WHERE T0.[DocDate]  >= @StartDate  and  T0.[DocDate]  <= @EndDate AND T0.DocType  NOT IN ('S') and T1.[ItemCode] not in ('K39',
'RSRTNIVEL1',
'RSRTNIVEL10',
'RSRTNIVEL100',
'RSRTNIVEL11',
'RSRTNIVEL12',
'RSRTNIVEL13',
'RSRTNIVEL14',
'RSRTNIVEL144',
'RSRTNIVEL15',
'RSRTNIVEL16',
'RSRTNIVEL17',
'RSRTNIVEL18',
'RSRTNIVEL19',
'RSRTNIVEL2',
'RSRTNIVEL20',
'RSRTNIVEL21',
'RSRTNIVEL217',
'RSRTNIVEL22',
'RSRTNIVEL23',
'RSRTNIVEL24',
'RSRTNIVEL25',
'RSRTNIVEL26',
'RSRTNIVEL27',
'RSRTNIVEL28',
'RSRTNIVEL29',
'RSRTNIVEL3',
'RSRTNIVEL30',
'RSRTNIVEL31',
'RSRTNIVEL32',
'RSRTNIVEL33',
'RSRTNIVEL34',
'RSRTNIVEL35',
'RSRTNIVEL36',
'RSRTNIVEL37',
'RSRTNIVEL38',
'RSRTNIVEL39',
'RSRTNIVEL4',
'RSRTNIVEL40',
'RSRTNIVEL41',
'RSRTNIVEL42',
'RSRTNIVEL43',
'RSRTNIVEL44',
'RSRTNIVEL45',
'RSRTNIVEL46',
'RSRTNIVEL47',
'RSRTNIVEL48',
'RSRTNIVEL49',
'RSRTNIVEL5',
'RSRTNIVEL50',
'RSRTNIVEL51',
'RSRTNIVEL52',
'RSRTNIVEL53',
'RSRTNIVEL54',
'RSRTNIVEL55',
'RSRTNIVEL56',
'RSRTNIVEL57',
'RSRTNIVEL58',
'RSRTNIVEL59',
'RSRTNIVEL6',
'RSRTNIVEL60',
'RSRTNIVEL61',
'RSRTNIVEL62',
'RSRTNIVEL63',
'RSRTNIVEL64',
'RSRTNIVEL65',
'RSRTNIVEL66',
'RSRTNIVEL67',
'RSRTNIVEL68',
'RSRTNIVEL69',
'RSRTNIVEL7',
'RSRTNIVEL70',
'RSRTNIVEL71',
'RSRTNIVEL72',
'RSRTNIVEL73',
'RSRTNIVEL74',
'RSRTNIVEL75',
'RSRTNIVEL76',
'RSRTNIVEL77',
'RSRTNIVEL78',
'RSRTNIVEL79',
'RSRTNIVEL8',
'RSRTNIVEL80',
'RSRTNIVEL81',
'RSRTNIVEL82',
'RSRTNIVEL83',
'RSRTNIVEL84',
'RSRTNIVEL85',
'RSRTNIVEL86',
'RSRTNIVEL87',
'RSRTNIVEL88',
'RSRTNIVEL89',
'RSRTNIVEL9',
'RSRTNIVEL90',
'RSRTNIVEL91',
'RSRTNIVEL92',
'RSRTNIVEL93',
'RSRTNIVEL94',
'RSRTNIVEL95',
'RSRTNIVEL96',
'RSRTNIVEL97',
'RSRTNIVEL98',
'RSRTNIVEL99',
'KS120',
'KS120-1',
'RSRTNIVEL'
)  and  (T0.CEECFlag not in ('Y') OR  T0.DocStatus not in ('C') OR  T0.InvntSttus not in ('C'))