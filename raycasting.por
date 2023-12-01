//baseado em https://lodev.org/cgtutor/raycasting.html

programa
{
	inclua biblioteca Tipos
	inclua biblioteca Matematica 
	inclua biblioteca Util
	inclua biblioteca Teclado
	inclua biblioteca Mouse
	inclua biblioteca Graficos

	const inteiro LARGURA_TELA = 320, ALTURA_TELA = 280

	const inteiro mapa[][] = {
		{1,1,1,1,1,1,1,1},
		{1,0,0,0,0,0,0,1},
		{1,0,0,1,1,0,0,1},
		{1,0,0,0,0,0,0,1},
		{1,0,0,0,0,0,0,1},
		{1,0,1,0,0,1,0,1},
		{1,0,1,0,0,1,0,1},
		{1,1,1,1,1,1,1,1}
	}
	 
	logico rodando = falso
	
	funcao inicio()
	{
		iniciar_graficos()
		loop()
	}

	funcao iniciar_graficos(){
		Graficos.iniciar_modo_grafico(verdadeiro)
		Graficos.definir_dimensoes_janela(LARGURA_TELA, ALTURA_TELA)
		Graficos.definir_titulo_janela("raycasting - portugol - feito por flaf")
	}
	
	funcao loop(){
		inteiro tempo_antigo = 0
		inteiro agora_tempo = 0
		inteiro variacao_tempo = 0
		real variacao_em_s

		agora_tempo = Util.tempo_decorrido()

		rodando = verdadeiro

		enquanto(rodando)
		{
			variacao_tempo = agora_tempo - tempo_antigo
			tempo_antigo = agora_tempo

			
			Graficos.definir_cor(Graficos.COR_BRANCO)
			Graficos.limpar()

			Graficos.definir_cor(0x27bcd6)
			Graficos.desenhar_retangulo(0, 0, LARGURA_TELA, ALTURA_TELA/2, falso, verdadeiro)
			Graficos.definir_cor(0x19272e)
			Graficos.desenhar_retangulo(0, ALTURA_TELA/2, LARGURA_TELA, ALTURA_TELA/2, falso, verdadeiro)

			//escreva("[debug] delta time: " + variacao_tempo + "\n")

			controle(variacao_tempo)
			renderizar()
			Graficos.renderizar()

			agora_tempo = Util.tempo_decorrido()
		}
	}
	real pos_x = 4
	real pos_y = 5
	real dir_x = -1
	real dir_y = 0

	real plano_x = 0
	real plano_y = 0.66
	funcao renderizar(){
		
		
		para(inteiro x = 0; x < LARGURA_TELA; x++){
			
			real camera_x = 2 * x / Tipos.inteiro_para_real(LARGURA_TELA) - 1
			real raio_dir_x = dir_x + plano_x * camera_x
			real raio_dir_y = dir_y + plano_y * camera_x

			inteiro mapa_x = pos_x
			inteiro mapa_y = pos_y

			real lado_dist_x
			real lado_dist_y

	

			real delta_dist_x = Matematica.valor_absoluto(1 / raio_dir_x)
			real delta_dist_y = Matematica.valor_absoluto(1 / raio_dir_y)
			real distancia_parede_perp

			inteiro step_x
			inteiro step_y

			logico atingiu_parede = falso
			logico vertical = falso

			se (raio_dir_x < 0){
				step_x = -1
				lado_dist_x = (pos_x - mapa_x) * delta_dist_x
			}senao{
				step_x = 1
				lado_dist_x = (mapa_x + 1.0 - pos_x) * delta_dist_x
			}
			se (raio_dir_y < 0){
				step_y = -1
				lado_dist_y = (pos_y - mapa_y) * delta_dist_y
			}senao{
				step_y = 1
				lado_dist_y = (mapa_y + 1.0 - pos_y) * delta_dist_y
			}

			enquanto(atingiu_parede == falso){
				se(lado_dist_x < lado_dist_y){
					lado_dist_x += delta_dist_x
					mapa_x += step_x
					vertical = falso
				}
				senao{
					lado_dist_y += delta_dist_y
					mapa_y += step_y
					vertical = verdadeiro
				}

				se(mapa[mapa_x][mapa_y] > 0) {
					atingiu_parede = verdadeiro
				}
			}
			se(nao vertical){
				distancia_parede_perp = (lado_dist_x - delta_dist_x)
			}senao{
				distancia_parede_perp = (lado_dist_y - delta_dist_y)
			}

			inteiro altura_linha = ALTURA_TELA / distancia_parede_perp

			se(vertical){
				Graficos.definir_cor(0xf5b727)
			}senao{
				Graficos.definir_cor(0xe6ab25)
			}
			

			inteiro linha_inicio = - altura_linha / 2 + ALTURA_TELA / 2
			se(linha_inicio < 0){
				linha_inicio = 0
			}
			inteiro linha_fim = altura_linha / 2 + ALTURA_TELA / 2
			se(linha_fim >= ALTURA_TELA){
				linha_fim = ALTURA_TELA - 1
			}
			Graficos.desenhar_linha(x, linha_inicio, x, linha_fim)
		}
		
	}
	real velocidade = 0.0025
	real velocidade_rotacao = 0.0025
	funcao controle(inteiro delta_tempo){
		se(Teclado.tecla_pressionada(Teclado.TECLA_W)){
			pos_x += dir_x * (velocidade * delta_tempo)
			pos_y += dir_y * (velocidade * delta_tempo)
		}
		se(Teclado.tecla_pressionada(Teclado.TECLA_S)){
			pos_x -= dir_x * (velocidade * delta_tempo)
			pos_y -= dir_y * (velocidade * delta_tempo)
		}
		se(Teclado.tecla_pressionada(Teclado.TECLA_A)){
			rotacionar(velocidade_rotacao * delta_tempo)
		}
		se(Teclado.tecla_pressionada(Teclado.TECLA_D)){
			rotacionar(-velocidade_rotacao * delta_tempo)
		}
		
	}

	funcao rotacionar(real rotacao){
 
		real cos = Matematica.cosseno(rotacao)
		real sen = Matematica.seno(rotacao)
		
		real dir_x_antigo = dir_x
		dir_x = dir_x * cos - dir_y * sen
		dir_y = dir_x_antigo * sen + dir_y * cos

		real plano_x_antigo = plano_x
		plano_x = plano_x * cos - plano_y * sen
		plano_y = plano_x_antigo * sen + plano_y * cos
		
	}

}
