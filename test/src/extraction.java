import java.io.File;
import java.io.IOException;

import twitter4j.internal.org.json.JSONArray;
import twitter4j.internal.org.json.JSONObject;

import net.sf.json.JSONException;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonToken;
import com.fourspaces.couchdb.Database;
import com.fourspaces.couchdb.Document;
import com.fourspaces.couchdb.Session;

public class extraction {
	static Session dbSession;

	static Database db;

	public static void main(String[] args)
			throws twitter4j.internal.org.json.JSONException {

		createDatabase("localhost", "db_fivegs");
		Document doc = new Document();
		JSONObject jObj = new JSONObject();

		try {

			JsonFactory jfactory = new JsonFactory();

			/*** read from file ***/
			JsonParser jParser = jfactory.createJsonParser(new File(
					args[0]));

			while (jParser.nextToken() != JsonToken.END_ARRAY) {

				//System.out.println("one done \n\n\n\n\n\n");

				while (jParser.nextToken() != JsonToken.END_OBJECT) {

					//System.out.println("running?");
					String fieldname = jParser.getCurrentName();
					if ("_id".equals(fieldname)) {

						while (jParser.nextToken() != JsonToken.END_OBJECT) {

						}

					}

					if ("contributors".equals(fieldname)) {

						String key = "contributors";
						jParser.nextToken();
						String value = jParser.getText();

						// System.out.println(key + ": " + value);

					}

					if ("lang".equals(fieldname)) {

						String key = "lang";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put(key, value);
						// System.out.println(key + ": " + value);

					}

					if ("retweeted_status".equals(fieldname)) {

						String key = "retweeted_status";
						// System.out.println(key);
						// jParser.nextToken();
						if (jParser.nextToken() != JsonToken.VALUE_NULL) {

							while (jParser.nextToken() != JsonToken.END_OBJECT) {
								String pM = jParser.getCurrentName();

								// System.out.println(key + "bla");
								// System.out.println(pM + "this is pM");
								if ("user".equals(pM)) {
									// System.out.println("blabla");
									while (jParser.nextToken() != JsonToken.END_OBJECT) {

									}
								}

								if ("geo".equals(pM)) {

									key = "geo";
									// System.out.println(key + "bla");
									if (jParser.nextToken() != JsonToken.VALUE_NULL) {
										while (jParser.nextToken() != JsonToken.END_OBJECT) {
											String fM = jParser
													.getCurrentName();

											if ("type".equals(fM)) {

												key = "type";
												jParser.nextToken();
												String value = jParser
														.getText();

												// System.out.println(key + ": "
												// + value);

											}

											if ("coordinates".equals(fM)) {

												key = "coordinates";
												jParser.nextToken();

												while (jParser.nextToken() != JsonToken.END_ARRAY) {
													jParser.getText();
												}

											}

										}
									}

								}

								if ("place".equals(pM)) {

									key = "place";
									// System.out.println(key + "bla");
									// System.out.println(jParser.nextToken());
									if (jParser.nextToken() != JsonToken.VALUE_NULL) {
										// System.out.println(key);
										// System.out.println(jParser.getCurrentToken());
										while (jParser.nextToken() != JsonToken.END_OBJECT) {

											String fM = jParser
													.getCurrentName();
											// System.out.println(fM);
											// jParser.nextToken();

											if ("country_code".equals(fM)) {

												key = "country_code";
												jParser.nextToken();
												String value = jParser
														.getText();

												// System.out.println(key + ": "
												// + value);

											}

											if ("url".equals(fM)) {

												key = "url";
												jParser.nextToken();
												String value = jParser
														.getText();

												// System.out.println(key + ": "
												// + value);

											}

											if ("country".equals(fM)) {

												key = "country";
												jParser.nextToken();
												String value = jParser
														.getText();

												// System.out.println(key + ": "
												// + value);

											}

											if ("place_type".equals(fM)) {

												key = "place_type";
												jParser.nextToken();
												String value = jParser
														.getText();

												// System.out.println(key + ": "
												// + value);

											}

											if ("bounding_box".equals(fM)) {
												jParser.getCurrentName();
												while (jParser.nextToken() != JsonToken.END_OBJECT) {

													jParser.getText();

												}
												jParser.getCurrentToken();
											}
											if ("full_name".equals(fM)) {

												key = "full_name";
												jParser.nextToken();
												String value = jParser
														.getText();

												// System.out.println(key + ": "
												// + value);

											}

											if ("attributes".equals(fM)) {

												key = "attributes";
												while (jParser.nextToken() != JsonToken.END_OBJECT) {

												}

											}

										}

									}

								}

								if ("coordinates".equals(pM)) {

									key = "coordinates";

									if (jParser.nextToken() != JsonToken.VALUE_NULL) {
										while (jParser.nextToken() != JsonToken.END_OBJECT) {

											String fM = jParser
													.getCurrentName();

											if ("type".equals(fM)) {

												key = "type";
												jParser.nextToken();
												String value = jParser
														.getText();
												//
												// System.out.println(key + ": "
												// + value);

											}

											if ("coordinates".equals(fM)) {

												key = "coordinates";

												jParser.nextToken();
												while (jParser.nextToken() != JsonToken.END_ARRAY) {

													// System.out.println(jParser
													// .getText());
												}

											}

										}
									}

								}

								if ("entities".equals(pM)) {

									key = "entities";
									// System.out.println(key + "bla");
									// System.out.println(key);
									while (jParser.nextToken() != JsonToken.END_OBJECT) {

										String fN = jParser.getCurrentName();

										// not done!!!
										if ("user_mentions".equals(fN)) {

											key = "user_mentions";
											// System.out.println(key);
											jParser.nextToken();

											while (jParser.nextToken() != JsonToken.END_ARRAY) {

												fN = jParser.getCurrentName();
												if ("indices".equals(fN)) {
													while (jParser.nextToken() != JsonToken.END_ARRAY) {

													}
												}
												// System.out.println(jParser.getText());

											}

										}

										if ("media".equals(fN)) {

											int cc = 0;
											key = "media";
											// System.out.println(key);
											jParser.nextToken();

											while (jParser.nextToken() != JsonToken.END_ARRAY) {

												while (jParser.nextToken() != JsonToken.END_OBJECT) {

													String fM = jParser
															.getCurrentName();
													if ("expanded_url"
															.equals(fM)) {

														key = "expanded_url";
														jParser.nextToken();
														String value = jParser
																.getText();

														// System.out.println(key
														// + ": " + value);

													}

													if ("url".equals(fM)) {

														key = "url";
														jParser.nextToken();
														String value = jParser
																.getText();

														// System.out.println(key
														// + ": " + value);

													}

													if ("media_url_https"
															.equals(fM)) {

														key = "media_url_https";
														jParser.nextToken();
														String value = jParser
																.getText();

														// System.out.println(key
														// + ": " + value);

													}

													if ("id_str".equals(fM)) {

														key = "id_str";
														jParser.nextToken();
														String value = jParser
																.getText();

														// System.out.println(key
														// + ": " + value);

													}

													if ("media_url".equals(fM)) {

														key = "media_url";
														jParser.nextToken();
														String value = jParser
																.getText();
														//
														// System.out.println(key
														// + ": " + value);

													}

													if ("type".equals(fM)) {

														key = "type";
														jParser.nextToken();
														String value = jParser
																.getText();
														//
														// System.out.println(key
														// + ": " + value);

													}

													if ("id".equals(fM)) {

														key = "id";
														jParser.nextToken();
														String value = jParser
																.getText();

														// System.out.println(key
														// + ": " + value);

													}

													if ("display_url"
															.equals(fM)) {

														key = "display_url";
														jParser.nextToken();
														String value = jParser
																.getText();

														// System.out.println(key
														// + ": " + value);

													}

													if ("indices".equals(fM)) {

														key = "indices";
														jParser.nextToken();

														while (jParser
																.nextToken() != JsonToken.END_ARRAY) {
															jParser.getText();
														}

													}

													if ("sizes".equals(fM)) {

														key = "sizes";
														jParser.nextToken();
														while (jParser
																.nextToken() != JsonToken.END_OBJECT) {
															fM = jParser
																	.getCurrentName();
															if ("large"
																	.equals(fM)) {

																key = "large";
																jParser.nextToken();
																while (jParser
																		.nextToken() != JsonToken.END_OBJECT) {
																	fM = jParser
																			.getCurrentName();
																	if ("h".equals(fM)) {

																		key = "h";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

																		System.out
																				.println(key
																						+ ": "
																						+ value);

																	}

																	if ("resize"
																			.equals(fM)) {

																		key = "resize";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

//																		System.out
//																				.println(key
//																						+ ": "
//																						+ value);

																	}

																	if ("w".equals(fM)) {

																		key = "w";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

																		System.out
																				.println(key
																						+ ": "
																						+ value);

																	}
																}

															}

															if ("medium"
																	.equals(fM)) {

																key = "medium";
																jParser.nextToken();
																while (jParser
																		.nextToken() != JsonToken.END_OBJECT) {
																	fM = jParser
																			.getCurrentName();
																	if ("h".equals(fM)) {

																		key = "h";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

																		System.out
																				.println(key
																						+ ": "
																						+ value);

																	}

																	if ("resize"
																			.equals(fM)) {

																		key = "resize";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

//																		System.out
//																				.println(key
//																						+ ": "
//																						+ value);

																	}

																	if ("w".equals(fM)) {

																		key = "w";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

																		System.out
																				.println(key
																						+ ": "
																						+ value);

																	}
																}

															}

															if ("thumb"
																	.equals(fM)) {

																key = "thumb";
																jParser.nextToken();
																while (jParser
																		.nextToken() != JsonToken.END_OBJECT) {
																	fM = jParser
																			.getCurrentName();
																	if ("h".equals(fM)) {

																		key = "h";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

																		System.out
																				.println(key
																						+ ": "
																						+ value);

																	}

																	if ("resize"
																			.equals(fM)) {

																		key = "resize";
																		jParser.nextToken();
																		String value = jParser
																				.getText();
//
//																		System.out
//																				.println(key
//																						+ ": "
//																						+ value);

																	}

																	if ("w".equals(fM)) {

																		key = "w";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

																		System.out
																				.println(key
																						+ ": "
																						+ value);

																	}
																}

															}

															if ("small"
																	.equals(fM)) {

																key = "small";
																jParser.nextToken();
																while (jParser
																		.nextToken() != JsonToken.END_OBJECT) {
																	fM = jParser
																			.getCurrentName();
																	if ("h".equals(fM)) {

																		key = "h";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

																		System.out
																				.println(key
																						+ ": "
																						+ value);

																	}

																	if ("resize"
																			.equals(fM)) {

																		key = "resize";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

//																		System.out
//																				.println(key
//																						+ ": "
//																						+ value);

																	}

																	if ("w".equals(fM)) {

																		key = "w";
																		jParser.nextToken();
																		String value = jParser
																				.getText();

																		System.out
																				.println(key
																						+ ": "
																						+ value);

																	}
																}

															}
														}

													}
												}
											}

										}

										if ("hashtags".equals(fN)) {

											key = "hashtags";
											// System.out.println(key);
											jParser.nextToken();
											while (jParser.nextToken() != JsonToken.END_ARRAY) {

												while (jParser.nextToken() != JsonToken.END_OBJECT) {
													String fM = jParser
															.getCurrentName();

												}

											}

										}

										if ("urls".equals(fN)) {

											key = "urls";

											jParser.nextToken();
											while (jParser.nextToken() != JsonToken.END_ARRAY) {

												while (jParser.nextToken() != JsonToken.END_OBJECT) {
													// System.out.println(jParser.getCurrentToken());
													String fM = jParser
															.getCurrentName();

													// System.out.println(fM);
													if ("indices".equals(fM)) {

														key = "indices";

														jParser.nextToken();
														while (jParser
																.nextToken() != JsonToken.END_ARRAY) {

															System.out
																	.println(jParser
																			.getText());
														}

													}

													if ("url".equals(fM)) {

														key = "url";
														jParser.nextToken();
														String value = jParser
																.getText();
														//
														// System.out.println(key
														// + ": " + value);

													}

													if ("expanded_url"
															.equals(fM)) {

														key = "expanded_url";
														jParser.nextToken();
														String value = jParser
																.getText();

														// System.out.println(key
														// + ": " + value);

													}

													if ("display_url"
															.equals(fM)) {

														key = "display_url";
														jParser.nextToken();
														String value = jParser
																.getText();

														// System.out.println(key
														// + ": " + value);

													}

												}

											}

										}

									}

								}

							}

						}
					}

					if ("truncated".equals(fieldname)) {

						String key = "truncated";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("truncated", value);
						// System.out.println(key + ": " + value);

					}

					if ("text".equals(fieldname)) {

						String key = "text";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("text", value);
						// System.out.println(key + ": " + value);

					}

					if ("in_reply_to_status_id".equals(fieldname)) {

						String key = "in_reply_to_status_id";
						jParser.nextToken();
						String value = jParser.getText();

						// System.out.println(key + ": " + value);

					}

					if ("id".equals(fieldname)) {

						String key = "id";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("id", value);
						doc.setId(value);
						// System.out.println(key + ": " + value);

					}

					if ("entities".equals(fieldname)) {

						String key = "entities";
						// System.out.println(key);
						while (jParser.nextToken() != JsonToken.END_OBJECT) {

							String fN = jParser.getCurrentName();

							// not done!!!
							if ("user_mentions".equals(fN)) {

								key = "user_mentions";
								// System.out.println(key);
								jParser.nextToken();

								while (jParser.nextToken() != JsonToken.END_ARRAY) {

									fN = jParser.getCurrentName();
									if ("indices".equals(fN)) {
										while (jParser.nextToken() != JsonToken.END_ARRAY) {

										}
									}
									// System.out.println(jParser.getText());

								}

							}

							if ("media".equals(fN)) {

								int cc = 0;
								key = "media";
								// System.out.println(key);
								jParser.nextToken();

								while (jParser.nextToken() != JsonToken.END_ARRAY) {

									while (jParser.nextToken() != JsonToken.END_OBJECT) {

										String fM = jParser.getCurrentName();
										if ("expanded_url".equals(fM)) {

											key = "expanded_url";
											jParser.nextToken();
											String value = jParser.getText();
											//
											// System.out.println(key + ": "
											// + value);

										}

										if ("url".equals(fM)) {

											key = "url";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

										if ("media_url_https".equals(fM)) {

											key = "media_url_https";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

										if ("id_str".equals(fM)) {

											key = "id_str";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

										if ("media_url".equals(fM)) {

											key = "media_url";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

										if ("type".equals(fM)) {

											key = "type";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

										if ("id".equals(fM)) {

											key = "id";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

										if ("display_url".equals(fM)) {

											key = "display_url";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

										if ("indices".equals(fM)) {

											key = "indices";
											jParser.nextToken();

											while (jParser.nextToken() != JsonToken.END_ARRAY) {
												jParser.getText();
											}

										}

										if ("sizes".equals(fM)) {

											key = "sizes";
											jParser.nextToken();
											while (jParser.nextToken() != JsonToken.END_OBJECT) {
												fM = jParser.getCurrentName();
												if ("large".equals(fM)) {

													key = "large";
													jParser.nextToken();
													while (jParser.nextToken() != JsonToken.END_OBJECT) {
														fM = jParser
																.getCurrentName();
														if ("h".equals(fM)) {

															key = "h";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}

														if ("resize".equals(fM)) {

															key = "resize";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}

														if ("w".equals(fM)) {

															key = "w";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}
													}

												}

												if ("medium".equals(fM)) {

													key = "medium";
													jParser.nextToken();
													while (jParser.nextToken() != JsonToken.END_OBJECT) {
														fM = jParser
																.getCurrentName();
														if ("h".equals(fM)) {

															key = "h";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}

														if ("resize".equals(fM)) {

															key = "resize";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}

														if ("w".equals(fM)) {

															key = "w";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}
													}

												}

												if ("thumb".equals(fM)) {

													key = "thumb";
													jParser.nextToken();
													while (jParser.nextToken() != JsonToken.END_OBJECT) {
														fM = jParser
																.getCurrentName();
														if ("h".equals(fM)) {

															key = "h";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}

														if ("resize".equals(fM)) {

															key = "resize";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}

														if ("w".equals(fM)) {

															key = "w";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}
													}

												}

												if ("small".equals(fM)) {

													key = "small";
													jParser.nextToken();
													while (jParser.nextToken() != JsonToken.END_OBJECT) {
														fM = jParser
																.getCurrentName();
														if ("h".equals(fM)) {

															key = "h";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}

														if ("resize".equals(fM)) {

															key = "resize";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}

														if ("w".equals(fM)) {

															key = "w";
															jParser.nextToken();
															String value = jParser
																	.getText();

															// System.out
															// .println(key
															// + ": "
															// + value);

														}
													}

												}
											}

										}
									}
								}

							}

							if ("hashtags".equals(fN)) {

								key = "hashtags";
								// System.out.println(key);
								jParser.nextToken();
								while (jParser.nextToken() != JsonToken.END_ARRAY) {

									while (jParser.nextToken() != JsonToken.END_OBJECT) {
										String fM = jParser.getCurrentName();

									}

								}

							}

							if ("urls".equals(fN)) {

								key = "urls";

								jParser.nextToken();
								while (jParser.nextToken() != JsonToken.END_ARRAY) {

									while (jParser.nextToken() != JsonToken.END_OBJECT) {
										// System.out.println(jParser.getCurrentToken());
										String fM = jParser.getCurrentName();

										// System.out.println(fM);
										if ("indices".equals(fM)) {

											key = "indices";

											jParser.nextToken();
											while (jParser.nextToken() != JsonToken.END_ARRAY) {

												jParser.getText();
											}

										}

										if ("url".equals(fM)) {

											key = "url";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

										if ("expanded_url".equals(fM)) {

											key = "expanded_url";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

										if ("display_url".equals(fM)) {

											key = "display_url";
											jParser.nextToken();
											String value = jParser.getText();

											// System.out.println(key + ": "
											// + value);

										}

									}

								}

							}

						}

					}

					if ("retweeted".equals(fieldname)) {

						String key = "retweeted";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("retweeted", value);
						// System.out.println(key + ": " + value);

					}

					if ("coordinates".equals(fieldname)) {

						String key = "coordinates";

						if (jParser.nextToken() != JsonToken.VALUE_NULL) {
							while (jParser.nextToken() != JsonToken.END_OBJECT) {

								String fM = jParser.getCurrentName();

								if ("type".equals(fM)) {

									key = "type";
									jParser.nextToken();
									String value = jParser.getText();

									// System.out.println(key + ": " + value);

								}

								if ("coordinates".equals(fM)) {

									key = "coordinates";

									jParser.nextToken();
									while (jParser.nextToken() != JsonToken.END_ARRAY) {

										jParser.getText();
									}

								}

							}
						}

					}

					if ("source".equals(fieldname)) {

						String key = "source";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("source", value);
						// System.out.println(key + ": " + value);

					}

					if ("in_reply_to_screen_name".equals(fieldname)) {

						String key = "in_reply_to_screen_name";
						jParser.nextToken();
						String value = jParser.getText();

						// System.out.println(key + ": " + value);

					}

					if ("in_reply_to_user_id".equals(fieldname)) {

						String key = "in_reply_to_user_id";
						jParser.nextToken();
						String value = jParser.getText();

						// System.out.println(key + ": " + value);

					}

					if ("retweet_count".equals(fieldname)) {

						String key = "retweet_count";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("retweet_count", value);
						// System.out.println(key + ": " + value);

					}

					if ("id_str".equals(fieldname)) {

						String key = "id_str";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("id_str", value);
						// System.out.println(key + ": " + value);

					}

					if ("favorited".equals(fieldname)) {

						String key = "favorited";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("favorited", value);
						// System.out.println(key + ": " + value); // display 29

					}

					if ("user".equals(fieldname)) {

						JSONObject user = new JSONObject();
						String key = "user";
						jParser.nextToken();

						while (jParser.nextToken() != JsonToken.END_OBJECT) {

							String fM = jParser.getCurrentName();

							if ("follow_request_sent".equals(fM)) {

								key = "follow_request_sent";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("follow_request_sent", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_use_background_image".equals(fM)) {

								key = "profile_use_background_image";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_use_background_image", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("default_profile_image".equals(fM)) {

								key = "default_profile_image";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("default_profile_image", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("geo_enabled".equals(fM)) {

								key = "geo_enabled";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("geo_enabled", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("verified".equals(fM)) {

								key = "verified";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("verified", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_image_url_https".equals(fM)) {

								key = "profile_image_url_https";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_image_url_https", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_sidebar_fill_color".equals(fM)) {

								key = "profile_sidebar_fill_color";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_sidebar_fill_color", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("is_translator".equals(fM)) {

								key = "is_translator";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("is_translator", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("id".equals(fM)) {

								key = "id";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("id", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_text_color".equals(fM)) {

								key = "profile_text_color";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_text_color", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("followers_count".equals(fM)) {

								key = "followers_count";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("followers_count", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("protected".equals(fM)) {

								key = "protected";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("protected", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("id_str".equals(fM)) {

								key = "id_str";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("id_str", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_background_color".equals(fM)) {

								key = "profile_background_color";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_background_color", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("listed_count".equals(fM)) {

								key = "listed_count";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("listed_count", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("utc_offset".equals(fM)) {

								key = "utc_offset";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("utc_offset", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("statuses_count".equals(fM)) {

								key = "statuses_count";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("statuses_count", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}
							if ("description".equals(fM)) {

								key = "description";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("description", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}
							if ("friends_count".equals(fM)) {

								key = "friends_count";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("friends_count", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("location".equals(fM)) {

								key = "location";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("location", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_link_color".equals(fM)) {

								key = "profile_link_color";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_link_color", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_image_url".equals(fM)) {

								key = "profile_image_url";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_image_url", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("notifications".equals(fM)) {

								key = "notifications";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("notifications", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("show_all_inline_media".equals(fM)) {

								key = "show_all_inline_media";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("show_all_inline_media", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_background_image_url_https".equals(fM)) {

								key = "profile_background_image_url_https";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_background_image_url_https",
										value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_background_image_url".equals(fM)) {

								key = "profile_background_image_url";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_background_image_url", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("name".equals(fM)) {

								key = "name";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("name", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("lang".equals(fM)) {

								key = "lang";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("lang", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("profile_background_tile".equals(fM)) {

								key = "profile_background_tile";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_background_tile", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("favourites_count".equals(fM)) {

								key = "favourites_count";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("favourites_count", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("screen_name".equals(fM)) {

								key = "screen_name";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("screen_name", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("url".equals(fM)) {

								key = "url";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("url", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("created_at".equals(fM)) {

								key = "created_at";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("created_at", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("contributors_enabled".equals(fM)) {

								key = "contributors_enabled";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("contributors_enabled", value);
								// System.out.println(key + ": " + value); //
								// display
								// 29

							}

							if ("time_zone".equals(fM)) {

								key = "time_zone";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("time_zone", value);

							}

							if ("profile_sidebar_border_color".equals(fM)) {

								key = "profile_sidebar_border_color";
								jParser.nextToken();
								String value = jParser.getText();

								user.put("profile_sidebar_border_color", value);

							}

							if ("default_profile".equals(fM)) {

								key = "default_profile";
								jParser.nextToken();
								String value = jParser.getText();
								user.put("default_profile", value);

							}

							if ("following".equals(fM)) {

								key = "following";
								jParser.nextToken();
								String value = jParser.getText();
								user.put("following", value);

							}

						}
						jObj.put("user", user);

					}

					if ("geo".equals(fieldname)) {

						JSONObject geo = new JSONObject();
						String key = "geo";
						if (jParser.nextToken() != JsonToken.VALUE_NULL) {
							while (jParser.nextToken() != JsonToken.END_OBJECT) {
								String fM = jParser.getCurrentName();

								if ("type".equals(fM)) {

									key = "type";
									jParser.nextToken();
									String value = jParser.getText();
									geo.put(key, value);

								}

								if ("coordinates".equals(fM)) {

									JSONArray coor = new JSONArray();
									key = "coordinates";
									jParser.nextToken();

									while (jParser.nextToken() != JsonToken.END_ARRAY) {
										// System.out.println();
										coor.put(jParser.getText());
									}
									geo.put(key, coor);

								}

							}

							jObj.put("geo", geo);
						}

					}

					if ("in_reply_to_user_id_str".equals(fieldname)) {

						String key = "in_reply_to_user_id_str";
						jParser.nextToken();
						String value = jParser.getText();

						// System.out.println(key + ": " + value); // display 29

					}

					if ("possibly_sensitive".equals(fieldname)) {

						String key = "possibly_sensitive";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("possibly_sensitive", value);
						// System.out.println(key + ": " + value); // display 29

					}

					if ("created_at".equals(fieldname)) {

						String key = "created_at";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("created_at", value);
						// System.out.println(key + ": " + value); // display 29

					}

					if ("possibly_sensitive_editable".equals(fieldname)) {

						String key = "possibly_sensitive_editable";
						jParser.nextToken();
						String value = jParser.getText();
						jObj.put("possibly_sensitive_editable", value);
						// System.out.println(key + ": " + value); // display 29

					}

					if ("in_reply_to_status_id_str".equals(fieldname)) {

						String key = "in_reply_to_status_id_str";
						jParser.nextToken();
						String value = jParser.getText();

						jObj.put("in_reply_to_status_id_str", value);
						// System.out.println(key + ": " + value); // display 29

					}

					if ("place".equals(fieldname)) {

						String key = "place";
						// System.out.println(jParser.nextToken());
						if (jParser.nextToken() != JsonToken.VALUE_NULL) {
							// System.out.println(key);
							// System.out.println(jParser.getCurrentToken());
							while (jParser.nextToken() != JsonToken.END_OBJECT) {

								String fM = jParser.getCurrentName();
								// System.out.println(fM);
								// jParser.nextToken();

								if ("country_code".equals(fM)) {

									key = "country_code";
									jParser.nextToken();
									String value = jParser.getText();

								}

								if ("url".equals(fM)) {

									key = "url";
									jParser.nextToken();
									String value = jParser.getText();

								}

								if ("country".equals(fM)) {

									key = "country";
									jParser.nextToken();
									String value = jParser.getText();

								}

								if ("place_type".equals(fM)) {

									key = "place_type";
									jParser.nextToken();
									String value = jParser.getText();

								}

								if ("bounding_box".equals(fM)) {
									jParser.getCurrentName();
									while (jParser.nextToken() != JsonToken.END_OBJECT) {

										jParser.getText();

									}
									jParser.getCurrentToken();
								}
								if ("full_name".equals(fM)) {

									key = "full_name";
									jParser.nextToken();
									String value = jParser.getText();

								}

								if ("attributes".equals(fM)) {

									key = "attributes";
									while (jParser.nextToken() != JsonToken.END_OBJECT) {

									}

								}

							}

						}

					}

				}

				doc.put("twits", jObj.toString());

				//System.out.println(doc.toString());
				try {

					//System.out.println("called");
					db.saveDocument(doc);

				} catch (Exception e) {
					
					
					System.err.println(e);
					//System.out.println(doc.toString());
					doc.clear();
					continue;

				}
				
				jObj = new JSONObject();
				doc.clear();
			}
			jParser.close();

			System.out.println("jobs done! yeah!!!");

		} catch (JsonGenerationException e) {

			e.printStackTrace();

		} catch (JSONException e) {

			e.printStackTrace();

		} catch (IOException e) {

			e.printStackTrace();

		}

	}

	public static void createDatabase(String ip, String dbName) {

		dbSession = new Session(ip, 5984);

		if (dbSession.getDatabaseNames().contains(dbName)) {
			db = dbSession.getDatabase(dbName);
		} else {
			db = dbSession.createDatabase(dbName);
		}
	}

}